WITH 
  cte AS
    (
      SELECT *, CASE WHEN brand1 < brand2 THEN concat(brand1, brand2, year)
                                          ELSE concat(brand2, brand1, year) END pair_id
      FROM brands
    ),

  cte_rn AS
    (
      SELECT *, row_number() OVER(PARTITION BY pair_id ORDER BY pair_id) AS rn
      FROM cte
    )
    
SELECT brand1, brand2, year, custom1, custom2, custom3, custom4
FROM cte_rn
WHERE rn = 1
OR (custom1 <> custom3 AND custom2 <> custom4);
