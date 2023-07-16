create table if not exists Artists (
	id SERIAL primary key,
	NAME VARCHAR(60) not null
);

create table if not exists Genre (
	id SERIAL primary key,
	NAME VARCHAR(20) not null
);

create table if not exists ArtistsGenre(
	artist_id INTEGER references Artists(id),
	genre_id INTEGER references Genre(id),
	constraint pk primary key (artist_id, genre_id)
);

create table if not exists Albums (
	id SERIAl primary key,
	NAME VARCHAR(60) not null,
	realease_date DATE not null
);

create table if not exists ArtistsAlbums (
	artist_id INTEGER references Artists(id),
	album_id INTEGER references Albums(id),
	constraint ArAl primary key (artist_id, album_id)
);

create table if not exists Songs (
	id SERIAL primary key,
	NAME VARCHAR(60) not null,
	duration NUMERIC not null,
	album_id INTEGER not null references Albums(id)
);

create table if not exists Collection (
	id SERIAL primary key,
	NAME VARCHAR(60) not null,
	release_date DATE not null
);

create table if not exists SongsCollection (
	song_id INTEGER references Songs(id),
	collection_id INTEGER references Collection(id),
	constraint SongColl primary key (song_id, collection_id)
);

--Задание 2:

-- название и продолжительность самого длинного трека
select duration, name from songs
group by name, duration
order by duration desc
limit 1;
--Название треков, продолжительность которых не менее 3,5 минут.
select name, duration from songs 
where duration > 3.5;

--Названия сборников, вышедших в период с 2018 по 2020 год включительно.
select name, release_date from collection
where release_date between '01-01-2018' and '31-12-2020';

--Исполнители, чьё имя состоит из одного слова.
select name from artists 
where name not like '% %';

--Название треков, которые содержат слово «мой» или «my».
select name from songs 
where name like '%my%' or name like '%мой%';

-- Задание 3:

--Количество исполнителей в каждом жанре.
select count(a.artist_id) as quantity, a.genre_id, name from artistsgenre a
left join genre g on a.genre_id = g.id
where artist_id = artist_id and genre_id = genre_id 
group by artist_id ,genre_id, name

--Количество треков, вошедших в альбомы 2019–2020 годов.
select count(s.album_id), a.realease_date, a.name from songs s
left join albums a on s.album_id = a.id 
where a.realease_date between '01-01-2019' and '31-12-2020'
group by s.album_id, a.realease_date, a.name

--Средняя продолжительность треков по каждому альбому.
select avg(s.duration), a.name from songs s
left join albums a on s.album_id = a.id
where s.duration > 1
group by a.name

--Все исполнители, которые не выпустили альбомы в 2020 году.
select distinct ar.name from artists ar
left join artistsalbums a on a.artist_id = ar.id
left join albums al on a.album_id = al.id
where al.realease_date not between '01-01-2020' and '31-12-2020'
group by ar.name

--Названия сборников, в которых присутствует конкретный исполнитель (выберите его сами).
select distinct c.name
from collection c
left join songscollection sc on c.id = sc.collection_id 
left join songs s on s.id = sc.song_id
left join albums a on a.id = s.album_id
left join artistsalbums am on am.album_id = a.id
left join artists ar on ar.id = am.artist_id 
where ar.name like '%%Gorilazz%%'
order by c.name