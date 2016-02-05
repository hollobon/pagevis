CREATE OR REPLACE FUNCTION show_page(table_name text, page integer, width integer default 128, skip_hole boolean default true)
RETURNS SETOF text
AS $$
    WITH line_pointers AS (
        -- This won't work properly if the block size is sufficiently large that more than 1000
        -- line pointers will fit on a page.
        SELECT to_char(lp, 'FM009')
               || CASE lp_flags
                   WHEN 0 THEN 'U' -- LP_UNUSED
                   WHEN 1 THEN 'N' -- LP_NORMAL
                   WHEN 2 THEN 'R' -- LP_REDIRECT
                   WHEN 3 THEN 'D' -- LP_DEAD
               END
        FROM heap_page_items(get_raw_page(table_name, page))
    ),
    tuples AS (
        SELECT '[' || lp || ']'
            || repeat(CASE WHEN t_xmax = 0 OR txid_current() <= t_xmax::text::int
                           THEN 'H'
                           ELSE '-'
                      END, t_hoff - length(lp::text) - 2)
            || repeat(CASE WHEN t_xmax = 0 OR txid_current() <= t_xmax::text::int
                           THEN '#'
                           ELSE '-'
                      END, lp_len - t_hoff)
            || repeat('.', coalesce(lead(lp_off) OVER (ORDER BY lp_off), current_setting('block_size')::int) - lp_off - lp_len)
        FROM heap_page_items(get_raw_page(table_name, page))
        ORDER BY lp_off
    ),
    rendered AS (
        SELECT repeat('P', lower - (SELECT count(*) * 4 FROM line_pointers)::int)
            || array_to_string(array(SELECT * FROM line_pointers), '')
            || repeat(' ', upper - lower)
            || array_to_string(array(SELECT * FROM tuples), '') page_string
        FROM page_header(get_raw_page(table_name, 0))),
    split AS (
        SELECT n,
               line[1] AS line,
               count(*) OVER (PARTITION BY line[1]) AS partition_count,
               row_number() OVER (PARTITION BY line[1]) AS partition_row
        FROM rendered,
             regexp_matches(page_string, '.{' || width || '}', 'g') WITH ORDINALITY matches(line, n)
        UNION ALL
        SELECT 999999,
               substring(page_string, current_setting('block_size')::int - (current_setting('block_size')::int % width) + 1),
               1,
               1
        FROM rendered
        ORDER BY n
    )
    SELECT CASE WHEN skip_hole AND line ~ '^ +$' AND partition_count > 1
                THEN '  << Hole - ' || partition_count || ' rows skipped >> '
                ELSE line
           END
    FROM split
    WHERE NOT skip_hole OR (line ~ '^ +$' AND partition_row = 1) OR line !~ '^ +$';
$$ LANGUAGE sql;
