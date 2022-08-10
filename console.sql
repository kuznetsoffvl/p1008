#TASK 02=================================================================================================

#--------------------------------------------------------------------------------------------------------
#1. Provide a query showing Customers (just their full names, customer ID and country) who are not
#   in the US.
select concat(LastName, ' ' , FirstName) FullName, Country
from customer
where Country <> 'USA';

#--------------------------------------------------------------------------------------------------------
#2. Provide a query only showing the Customers from Brazil.
select concat(LastName, ' ' , FirstName) FullName, Country
from customer
where Country = 'Brazil';

#--------------------------------------------------------------------------------------------------------
#3. Provide a query showing the Invoices of customers who are from Brazil. The resultant table should show
#   the customer’s full name, Invoice ID, Date of the invoice and billing country.
select
    concat(LastName, ' ' , FirstName) FullName,
    InvoiceId,
    InvoiceDate,
    BillingCountry
from invoice
         join customer c on c.CustomerId = invoice.CustomerId
where Country = 'Brazil';

#--------------------------------------------------------------------------------------------------------
#4. Provide a query showing only the Employees who are Sales Agents.
select
    *
from employee
where Title like 'Sales%Agent';

#--------------------------------------------------------------------------------------------------------
#5. Provide a query showing a unique list of billing countries from the Invoice table.
select distinct BillingCountry
from invoice;

#--------------------------------------------------------------------------------------------------------
#6. Provide a query that shows the invoices associated with each sales agent. The resultant table should
#   include the Sales Agent’s full name.
select
    i.InvoiceId,
    i.InvoiceDate,
    i.Total,
    concat(e.LastName, ' ' , e.FirstName) FullName
from invoice i
         join customer c on c.CustomerId = i.CustomerId
         join employee e on e.EmployeeId = c.SupportRepId;

#--------------------------------------------------------------------------------------------------------
#7. Provide a query that shows the Invoice Total, Customer name, Country and Sale Agent name for all
#   invoices and customers.
select
    i.Total,
    concat(c.FirstName, ' ' , c.LastName) CustomerFullName,
    c.Country,
    concat(e.FirstName, ' ' , e.LastName) AgentFullName
from invoice i
         join customer c on i.CustomerId = c.CustomerId
         join employee e on e.EmployeeId = c.SupportRepId
where e.Title like 'Sales%Agent';

#--------------------------------------------------------------------------------------------------------
#8. How many Invoices were there in 2009 and 2011? What are the respective total sales for each of those
#   years?
select
    count(*)
from invoice
where year(InvoiceDate) = 2009 or year(InvoiceDate) = 2011;

#--------------------------------------------------------------------------------------------------------
#9. Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for Invoice ID 37.
select count(*)
from invoiceline
where InvoiceId = 37;

#--------------------------------------------------------------------------------------------------------
#10. Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for each
#    Invoice. HINT: GROUP BY
select
    i.InvoiceId,
    count(i.InvoiceLineId) count
from invoiceline i
group by i.InvoiceId;

#TASK 03=================================================================================================

#--------------------------------------------------------------------------------------------------------
#1. Provide a query that includes the track name with each invoice line item.
select iline.InvoiceLineId, t.Name
from invoiceline iline
join track t on t.TrackId = iline.TrackId
order by InvoiceLineId;

#--------------------------------------------------------------------------------------------------------
#2. Provide a query that includes the purchased track name AND artist name with each invoice line item.
select t.Name as Track, ar.Name as Artist, iline.InvoiceLineId as InvoiceLineId
from invoiceline iline
join track t on t.TrackId = iline.TrackId
join album a on t.AlbumId = a.AlbumId
join artist ar on ar.ArtistId = a.ArtistId;

#--------------------------------------------------------------------------------------------------------
#3. Provide a query that shows the # of invoices per country. HINT: GROUP BY
select i.BillingCountry, count(i.InvoiceId) as count
from invoice i
group by i.BillingCountry;

#--------------------------------------------------------------------------------------------------------
#4. Provide a query that shows the total number of tracks in each playlist. The Playlist name should be
#   included on the resultant table.
select p.Name as Playlist, count(p2.TrackId)
from playlisttrack as p2
join playlist p on p.PlaylistId = p2.PlaylistId
group by p.PlaylistId;

#--------------------------------------------------------------------------------------------------------
#5. Provide a query that shows all the Tracks, but displays no IDs. The resultant table should include the
#   Album name, Media type and Genre.
select t.Name as Track, a.Title as Album, m.Name as MediaType, g.Name as Genre
from track t
join album a on a.AlbumId = t.AlbumId
join mediatype m on m.MediaTypeId = t.MediaTypeId
join genre g on g.GenreId = t.GenreId;

#--------------------------------------------------------------------------------------------------------
#6. Provide a query that shows all Invoices but includes the # of invoice line items.
select distinct inv.InvoiceId, count(il.InvoiceLineId) as '#'
from invoice inv
join invoiceline il on inv.InvoiceId = il.InvoiceId
group by inv.InvoiceId;

#--------------------------------------------------------------------------------------------------------
#7. Provide a query that shows total sales made by each sales agent.
select
    concat(e.FirstName, ' ' , e.LastName) as Agent,
    sum(i.Total) as 'Total sales'
from invoice i
join customer c on c.CustomerId = i.CustomerId
join employee e on e.EmployeeId = c.SupportRepId
where e.Title like 'Sales%Agent'
group by Agent;

#--------------------------------------------------------------------------------------------------------
#8. Which sales agent made the most in sales in 2009?
select
    concat(e.FirstName, ' ' , e.LastName) as Agent,
    sum(i.Total) as TotalSales
from invoice i
         join customer c on c.CustomerId = i.CustomerId
         join employee e on e.EmployeeId = c.SupportRepId
where e.Title like 'Sales%Agent' and year(i.InvoiceDate) = 2009
group by Agent
order by TotalSales DESC
limit 1;

#--------------------------------------------------------------------------------------------------------
#9. Which sales agent made the most in sales in 2010?
select
    concat(e.FirstName, ' ' , e.LastName) as Agent,
    sum(i.Total) as TotalSales
from invoice i
         join customer c on c.CustomerId = i.CustomerId
         join employee e on e.EmployeeId = c.SupportRepId
where e.Title like 'Sales%Agent' and year(i.InvoiceDate) = 2010
group by Agent
order by TotalSales DESC
limit 1;

#--------------------------------------------------------------------------------------------------------
#10. Which sales agent made the most in sales over all?
select
    total.Agent,
    max(total.TotalSales)
from (
    select
        concat(e.FirstName, ' ' , e.LastName) as Agent,
        sum(i.Total) as TotalSales
    from invoice i
             join customer c on c.CustomerId = i.CustomerId
             join employee e on e.EmployeeId = c.SupportRepId
    where e.Title like 'Sales%Agent'
    group by Agent
    order by TotalSales DESC
) as total;


#TASK 04=================================================================================================

#--------------------------------------------------------------------------------------------------------
#1. Provide a query that shows the # of customers assigned to each sales agent.
select
    concat(e.FirstName, ' ' , e.LastName) as Agent,
    count(c.CustomerId)
from customer c
join employee e on e.EmployeeId = c.SupportRepId
-- where e.Title like 'Sales%Agent'
group by  Agent;

#--------------------------------------------------------------------------------------------------------
#2. Provide a query that shows the total sales per country.
select
    i.BillingCountry, sum(i.Total) as TotalSales
from invoice i
group by i.BillingCountry;

#--------------------------------------------------------------------------------------------------------
#3. Which country’s customers spent the most?
select
    NestedQuery.Country    as Country,
    max(NestedQuery.TotalSales) as TotalSales
from (select c.Country    as Country,
             sum(i.Total) as TotalSales
      from invoice i
               join customer c on c.CustomerId = i.CustomerId
      group by Country
      order by sum(i.Total) DESC ) as NestedQuery;

#--------------------------------------------------------------------------------------------------------
#4. Provide a query that shows the most purchased track of 2013.
select
    ar.Name as Artist,
    t.Name as Track,
    sum(i.Total) as TotalSales
from invoice i
         join invoiceline il on i.InvoiceId = il.InvoiceId
         join track t on t.TrackId = il.TrackId
         join album a on t.AlbumId = a.AlbumId
         join artist ar on ar.ArtistId = a.ArtistId
where year(i.InvoiceDate) = 2013
group by Track
order by TotalSales Desc
limit 1;

#--------------------------------------------------------------------------------------------------------
#5. Provide a query that shows the top 5 most purchased tracks over all.
select distinct
    t.Name as Track,
    sum(i.Total) as TotalSales
from invoice i
join invoiceline i2 on i.InvoiceId = i2.InvoiceId
join track t on t.TrackId = i2.TrackId
group by Track
order by TotalSales DESC
limit 5;

#--------------------------------------------------------------------------------------------------------
#6. Provide a query that shows the top 3 best selling artists.
select
    a2.Name as Artist,
    sum(i.Total) as TotalSales
from invoice i
join invoiceline i2 on i.InvoiceId = i2.InvoiceId
join track t on t.TrackId = i2.TrackId
join album a on a.AlbumId = t.AlbumId
join artist a2 on a2.ArtistId = a.ArtistId
group by Artist
order by TotalSales DESC
limit 3;

#--------------------------------------------------------------------------------------------------------
#7. Provide a query that shows the most purchased Media Type.
select
    m.Name as MediaType,
    sum(i.Total) as TotalSales
from invoice i
join invoiceline i2 on i.InvoiceId = i2.InvoiceId
join track t on i2.TrackId = t.TrackId
join mediatype m on m.MediaTypeId = t.MediaTypeId
group by MediaType
order by TotalSales DESC
limit 1;