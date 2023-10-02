SELECT * FROM album
Q1: who is the senior most employee based on job title?

SELECT * FROM employee
ORDER BY levels DESC
LIMIT 1
ANS:MADAN

q2:which countries have the most invoices?

SELECT * FROM invoice
SELECT COUNT(*)as c,billing_country from invoice
group by billing_country
order by c desc

q3:what are the top 3 values of total invoice?
select total from invoice
order by total desc
limit 3

q4:which city has the best customers?write a query returns one city has highest sum of invoice totals and
returns both city name & sum of all invoice totals

select * from invoice

select SUM(total) as invoice_total, billing_city 
from invoice
group by billing_city
order by invoice_total desc

q5:who is the best customer? query to return person who has spent the most money.

select * from customer

select customer.customer_id,customer.first_name,customer.last_name,SUM(invoice.total) as total
from customer
JOIN invoice ON customer.customer_id = invoice.customer_id
group by customer.customer_id
order by total desc
limit 1

set 2 
q1: write query to return email,first name ,last name& genre of all the rock music listeners.
return your list ordered alphabetically by email starting with A

select * from track

select distinct email,first_name,last_name
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in(
	select track_id from track
	join genre on track.genre_id = genre.genre_id
	where genre.name like 'Rock'
)
order by email;

q2: inviting artists who have written the most rock music in dataset.query returns artist name,and 
total track count of the top 10 rock bands.

select * from track

select artist.artist_id,artist.name,COUNT(artist.artist_id) as no_of_songs
from track
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name like 'Rock'
group by artist.artist_id
order by no_of_songs desc
limit 10;

q3:return all track names that have a song length longer than the average song length.
return naME, milliseconds for each track.order by the song length with the longest songs
listed first.

select name,milliseconds
from track
where milliseconds > (
	select AVG(milliseconds) as avg_track_length
	from track 
)
order by milliseconds desc;

set 3
q1:find how much amount spent by each customer on artists?
write a query to return customer name,artist name and total spent.

WITH best_selling_artist AS (
	select artist.artist_id as artist_id,artist.name as artist_name,
	SUM(invoice_line.unit_price * invoice_line.quantity) as total_sales
	from invoice_line
	join track on invoice_line.track_id = track.track_id
	join album on album.album_id = track.album_id
	join artist on artist.artist_id = album.artist_id
	group by 1
	order by 3 desc
	limit 1
)
select c.customer_id,c.first_name,c.last_name,bsa.artist_name,SUM(il.unit_price*il.quantity) as amount_spent
from invoice i
join customer c on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on t.track_id = il.track_id
join album on album.album_id = t.album_id
join best_selling_artist bsa on bsa.artist_id = album.artist_id
group by 1,2,3,4
order by 5 desc;

q2:find out the most popular music genre for each country.we determine the most popular genre with the highest amount
of purchases.write a query returns each country along with the top genre. for countries where maximum no of purchases is 
shared return all genres.

with popular_genre as(
	select COUNT(invoice_line.quantity) as purchases,customer.country,genre.name,genre.genre_id,
	ROW_NUMBER() OVER(PARTITION BY customer.country order by COUNT(invoice_line.quantity)DESC) as rowno
	from invoice_line 
	join invoice on invoice.invoice_id = invoice_line.invoice_id
	join customer on customer.customer_id = invoice.customer_id
	join track on track.track_id = invoice_line.track_id
	join genre on genre.genre_id = track.genre_id
	group by 2,3,4
	order by 2 asc,1 desc
)
select * from popular_genre where rowno <= 1

q3: query to determine the customer that has spent the most on music for each country. query returns the country along with the 
top customer and how much they spent.for countries where the top amount spent is shared,provide all customers who spent 
his amount.

with customer_with_country as (
	select customer.customer_id,customer.first_name,customer.last_name,invoice.billing_country,sum(total) as total_spending,
	ROW_NUMBER() OVER(PARTITION BY billing_country order by SUM(total) DESC) as rowno
	from invoice
	join customer on invoice.customer_id = customer.customer_id
	group by 1,2,3,4
	order by 4 ASC,5 DESC
)
select * from customer_with_country where rowno <= 1

	
	
	
	
	
	



