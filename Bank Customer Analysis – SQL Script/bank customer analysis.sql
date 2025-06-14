USE banca

SELECT * FROM cliente LIMIT 5 -- id_cliente
SELECT * FROM conto LIMIT 5 -- id_cliente, id_conto, id_tipo_conto
SELECT * FROM tipo_conto LIMIT 5 -- id_tipo_conto
SELECT * FROM tipo_transazione LIMIT 5 -- id_tipo_transazione --- 
SELECT * FROM transazioni LIMIT 5 -- id_conto, id_tipo_trans --- 

SELECT
c.id_cliente, count(DISTINCT co.id_conto) AS num_conti, tc.desc_tipo_conto,
--t.id_tipo_trans AS id_tipo_transazione, 
t.id_tipo_trans,
tt.desc_tipo_trans, tt.segno 
FROM cliente c 
LEFT JOIN conto co ON c.id_cliente = co.id_cliente
LEFT JOIN tipo_conto tc ON tc.id_tipo_conto = co.id_tipo_conto
LEFT JOIN transazioni t ON t.id_conto = co.id_conto
LEFT JOIN tipo_transazione tt ON tt.id_tipo_transazione = t.id_tipo_trans
GROUP BY 1,3,4,5,6
ORDER BY num_conti  DESC

SELECT c.*, timestampdiff(year,c.data_nascita, curdate()) AS eta 
FROM cliente c

/*
INDICATORI SULLE TRANSAZIONI
*/


SELECT c.id_cliente,
count(CASE WHEN tt.segno = '-' THEN tt.id_tipo_transazione ELSE NULL END) AS num_trans_in_uscita,
count(CASE WHEN tt.segno = '+' THEN  tt.id_tipo_transazione ELSE NULL END) AS num_trans_in_entrata,
sum(CASE WHEN tt.segno='-' THEN t.importo END) AS importo_tot_in_uscita,
sum(CASE WHEN tt.segno='+' THEN t.importo END) AS importo_tot_in_entrata
FROM cliente c 
LEFT JOIN conto co ON c.id_cliente = co.id_cliente
LEFT JOIN transazioni t ON t.id_conto = co.id_conto
LEFT JOIN tipo_transazione tt ON tt.id_tipo_transazione = t.id_tipo_trans
-- where c.id_cliente='139'-- test
GROUP BY 1
ORDER BY importo_tot_in_uscita DESC

/*
INDICATORI SUI CONTI
*/

SELECT c.id_cliente, 
count(DISTINCT co.id_conto) AS num_conti_tot,
count(DISTINCT CASE WHEN tc.desc_tipo_conto = 'Conto Base' THEN co.id_conto END) num_conti_base,
count(DISTINCT CASE WHEN tc.desc_tipo_conto = 'Conto Business' THEN co.id_conto END) num_conti_business,
count(DISTINCT CASE WHEN tc.desc_tipo_conto = 'Conto Privati' THEN co.id_conto END) num_conti_privati,
count(DISTINCT CASE WHEN tc.desc_tipo_conto = 'Conto Famiglie' THEN co.id_conto END) num_conti_famiglie
FROM cliente c 
LEFT JOIN conto co ON co.id_cliente = c.id_cliente
LEFT JOIN tipo_conto tc ON tc.id_tipo_conto = co.id_tipo_conto
GROUP BY 1 
ORDER BY num_conti_tot DESC

/*
INDICATORI SULLE TRANSAZIONI PER TIPOLOGIA DI CONTO
*/

SELECT c.id_cliente, 
-- conto base
count(CASE WHEN tt.segno = '-' AND tc.desc_tipo_conto = 'Conto Base' THEN t.id_tipo_trans END) count_trans_in_uscita_contoBase,
count(CASE WHEN tt.segno = '+' AND tc.desc_tipo_conto = 'Conto Base' THEN t.id_tipo_trans END) count_trans_in_entrata_contoBase,
sum(CASE WHEN tt.segno ='-' AND tc.desc_tipo_conto = 'Conto Base' THEN t.importo END) importo_tot_in_uscita_contoBase,
sum(CASE WHEN tt.segno ='+' AND tc.desc_tipo_conto = 'Conto Base' THEN t.importo END) importo_tot_in_entrata_contoBase,
-- conto business
count(CASE WHEN tt.segno = '-' AND tc.desc_tipo_conto = 'Conto Business' THEN t.id_tipo_trans END) count_trans_in_uscita_contoBusiness,
count(CASE WHEN tt.segno = '+' AND tc.desc_tipo_conto = 'Conto Business' THEN t.id_tipo_trans END) count_trans_in_entrata_contoBusiness,
sum(CASE WHEN tt.segno ='-' AND tc.desc_tipo_conto = 'Conto Business' THEN t.importo END) importo_tot_in_uscita_contoBusiness,
sum(CASE WHEN tt.segno ='+' AND tc.desc_tipo_conto = 'Conto Business' THEN t.importo END) importo_tot_in_entrata_contoBusiness,
-- conto privati
count(CASE WHEN tt.segno = '-' AND tc.desc_tipo_conto = 'Conto Privati' THEN t.id_tipo_trans END) num_trans_in_uscita_contoPrivati,
count( CASE WHEN tt.segno = '+' AND tc.desc_tipo_conto = 'Conto Privati' THEN t.id_tipo_trans END) num_trans_in_entrata_contoPrivati,
sum(CASE WHEN tt.segno ='-' AND tc.desc_tipo_conto = 'Conto Privati' THEN t.importo END) importo_tot_in_uscita_contoPrivati,
sum(CASE WHEN tt.segno ='+' AND tc.desc_tipo_conto = 'Conto Privati' THEN t.importo END) importo_tot_in_entrata_contoPrivati,
-- conto famiglie
count(CASE WHEN tt.segno = '-' AND tc.desc_tipo_conto = 'Conto Famiglie' THEN t.id_tipo_trans END) count_trans_in_uscita_contoFam,
count( CASE WHEN tt.segno = '+' AND tc.desc_tipo_conto = 'Conto Famiglie' THEN t.id_tipo_trans END) count_trans_in_entrata_contoFam,
sum(CASE WHEN tt.segno ='-' AND tc.desc_tipo_conto = 'Conto Famiglie' THEN t.importo END) importo_tot_in_uscita_contoFam,
sum(CASE WHEN tt.segno ='+' AND tc.desc_tipo_conto = 'Conto Famiglie' THEN t.importo END) importo_tot_in_entrata_contoFam
FROM cliente c
LEFT JOIN conto co ON co.id_cliente = c.id_cliente
LEFT JOIN tipo_conto tc ON tc.id_tipo_conto = co.id_tipo_conto
LEFT JOIN transazioni t ON t.id_conto = co.id_conto
LEFT JOIN tipo_transazione tt ON tt.id_tipo_transazione = t.id_tipo_trans
GROUP BY 1






/*
TABELLA DENORMALIZZATA FINALE
*/

SELECT c.*, TIMESTAMPDIFF(year,c.data_nascita, curdate()) AS eta,

-- IND SUI CONTI
count(DISTINCT co.id_conto) AS count_conti_tot,
count(DISTINCT CASE WHEN tc.desc_tipo_conto = 'Conto Base' THEN co.id_conto END) count_conti_base,
count(DISTINCT CASE WHEN tc.desc_tipo_conto = 'Conto Business' THEN co.id_conto END) count_conti_business,
count(DISTINCT CASE WHEN tc.desc_tipo_conto = 'Conto Privati' THEN co.id_conto END) count_conti_privati,
count(DISTINCT CASE WHEN tc.desc_tipo_conto = 'Conto Famiglie' THEN co.id_conto END) count_conti_famiglie,

-- IND TRANSAZIONI GLOBALI
count(CASE WHEN tt.segno = '-' THEN tt.id_tipo_transazione END) AS count_trans_in_uscita,
count(CASE WHEN tt.segno = '+' THEN  tt.id_tipo_transazione END) AS count_trans_in_entrata, 
sum(CASE WHEN tt.segno='-' THEN t.importo ELSE 0 END) AS importo_tot_in_uscita,
sum(CASE WHEN tt.segno='+' THEN t.importo ELSE 0 END) AS importo_tot_in_entrata,

-- IND SULLE TRANSAZIONI PER TIPOLOGIA DI CONTO
-- conto base
count(CASE WHEN tt.segno = '-' AND tc.desc_tipo_conto = 'Conto Base' THEN t.id_tipo_trans END) count_trans_in_uscita_contoBase,
count(CASE WHEN tt.segno = '+' AND tc.desc_tipo_conto = 'Conto Base' THEN t.id_tipo_trans END) count_trans_in_entrata_contoBase,
sum(CASE WHEN tt.segno ='-' AND tc.desc_tipo_conto = 'Conto Base' THEN t.importo ELSE 0 END) importo_tot_in_uscita_contoBase,
sum(CASE WHEN tt.segno ='+' AND tc.desc_tipo_conto = 'Conto Base' THEN t.importo ELSE 0 END) importo_tot_in_entrata_contoBase,
-- conto business
count(CASE WHEN tt.segno = '-' AND tc.desc_tipo_conto = 'Conto Business' THEN t.id_tipo_trans END) count_trans_in_uscita_contoBusiness,
count(CASE WHEN tt.segno = '+' AND tc.desc_tipo_conto = 'Conto Business' THEN t.id_tipo_trans END) count_trans_in_entrata_contoBusiness,
sum(CASE WHEN tt.segno ='-' AND tc.desc_tipo_conto = 'Conto Business' THEN t.importo ELSE 0 END) importo_tot_in_uscita_contoBusiness,
sum(CASE WHEN tt.segno ='+' AND tc.desc_tipo_conto = 'Conto Business' THEN t.importo ELSE 0 END) importo_tot_in_entrata_contoBusiness,
-- conto privati
count(CASE WHEN tt.segno = '-' AND tc.desc_tipo_conto = 'Conto Privati' THEN t.id_tipo_trans END) count_trans_in_uscita_contoPrivati,
count( CASE WHEN tt.segno = '+' AND tc.desc_tipo_conto = 'Conto Privati' THEN t.id_tipo_trans END) count_trans_in_entrata_contoPrivati,
sum(CASE WHEN tt.segno ='-' AND tc.desc_tipo_conto = 'Conto Privati' THEN t.importo ELSE 0 END) importo_tot_in_uscita_contoPrivati,
sum(CASE WHEN tt.segno ='+' AND tc.desc_tipo_conto = 'Conto Privati' THEN t.importo ELSE 0 END) importo_tot_in_entrata_contoPrivati,
-- conto famiglie
count(CASE WHEN tt.segno = '-' AND tc.desc_tipo_conto = 'Conto Famiglie' THEN t.id_tipo_trans END) count_trans_in_uscita_contoFam,
count( CASE WHEN tt.segno = '+' AND tc.desc_tipo_conto = 'Conto Famiglie' THEN t.id_tipo_trans END) count_trans_in_entrata_contoFam,
sum(CASE WHEN tt.segno ='-' AND tc.desc_tipo_conto = 'Conto Famiglie' THEN t.importo ELSE 0 END) importo_tot_in_uscita_contoFam,
sum(CASE WHEN tt.segno ='+' AND tc.desc_tipo_conto = 'Conto Famiglie' THEN t.importo ELSE 0 END) importo_tot_in_entrata_contoFam
FROM cliente c
LEFT JOIN conto co ON co.id_cliente = c.id_cliente
LEFT JOIN tipo_conto tc ON tc.id_tipo_conto = co.id_tipo_conto
LEFT JOIN transazioni t ON t.id_conto = co.id_conto
LEFT JOIN tipo_transazione tt ON tt.id_tipo_transazione = t.id_tipo_trans
GROUP BY c.id_cliente, c.data_nascita
ORDER BY c.id_cliente



