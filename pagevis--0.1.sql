CREATE OR REPLACE FUNCTION show_page(table_name text, page integer, width integer default 128)
RETURNS SETOF text
AS $$
    WITH line_pointers AS (
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
    )
    SELECT unnest(regexp_matches(
           repeat('P', lower - (SELECT count(*) * 4 FROM line_pointers)::int)
        || array_to_string(array(SELECT * FROM line_pointers), '')
        || repeat(' ', upper - lower)
        || array_to_string(array(SELECT * FROM tuples), ''), '.{' || width || '}', 'g'))
    FROM page_header(get_raw_page(table_name, page));
$$ LANGUAGE sql;

