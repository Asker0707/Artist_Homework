create table if not exists Artists (
	id SERIAL primary key,
	NAME VARCHAR(60) not null
);

create table if not exists Genre (
	id SERIAL primary key,
	NAME VARCHAR(20) unique not null 
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
	duration INTEGER not null,
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

--Вставка данных

insert into artists(name)
values ('The Weeknd'), ('Gorilazz'), ('Lady Gaga'), ('Justin Timberlake');

insert into albums(name, realease_date)
values ('Starboy', '24-11-2016'), ('After Hours', '20-03-2020'), ('Demon Days', '11-05-2005'), ('Plastic Beach', '03-03-2019'),
('The Fame', '01-01-2008'), ('Born this way', '01-01-2011'), ('Justified', '04-11-2002'), ('Love Sounds', '08-09-2006');

insert into genre(name)
values ('Pop'), ('Hip Hop'), ('Folk'), ('Country');

insert into songs(name, duration, album_id)
values ('Secrets', '465', '1'), ('True Colors', '206', '1'),
('Alone Again', '250', '2'), ('My mind', '189', '2'),
('My', '63', '3'), ('Feel Good', '221', '3'),
('Last Night Myself', '307', '4'), ('Still on My Brain', '415', '4'),
('Never Again', '487', '5'), ('Right for Me', '224', '5'),
('Like I Love You', '187', '6'), ('That Girl Be My', '290', '6'),
('Mirrors Premyne', '372', '7'), ('Body Count Myself By', '318', '7'),
('Help me beemy', '167', '8'), ('Spaceship Coupe', '398', '8');

insert into collection(name, release_date)
values ('Hit music', '03-06-2020'), ('The Most Popular Songs', '02-04-2019'),
('Dance Music', '09-09-2015'), ('Romantic Collection', '30-08-2017');

insert into artistsalbums(artist_id, album_id)
values ('1', '1'), ('1', '2'), ('2', '3'), ('2', '4'),
('3', '5') , ('3', '6'), ('4', '7'), ('4', '8');

insert into artistsgenre(artist_id, genre_id)
values ('1', '1'), ('2', '2'), ('3', '3'), ('4', '4');

insert into songscollection(collection_id, song_id)
select 1 id, x
from unnest(array[2, 5, 7, 8]) x

insert into songscollection(collection_id, song_id)
select 2 id, x
from unnest(array[3, 1, 9, 10]) x

insert into songscollection(collection_id, song_id)
select 3 id, x
from unnest(array[4, 6, 11, 15]) x

insert into songscollection(collection_id, song_id)
select 4 id, x
from unnest(array[12, 13, 14, 16]) x


-- название и продолжительность самого длинного трека
select duration, name from songs
group by name, duration
order by duration desc
limit 1;

--Название треков, продолжительность которых не менее 3,5 минут.
select name, duration from songs 
where duration >= 210;

--Названия сборников, вышедших в период с 2018 по 2020 год включительно.
select name, release_date from collection
where release_date between '01-01-2018' and '31-12-2020';

--Исполнители, чьё имя состоит из одного слова.
select name from artists 
where name not like '% %';

--Название треков, которые содержат слово «мой» или «my». 
select name from songs 
where name ilike 'my %' or name ilike '% my' or name ilike '% my %' or name ilike 'my';
--Не стал дублировать эту же схему с вариантом 'мой', так как отсуствуют русскоязычные названия.


-- Задание 3:

--Количество исполнителей в каждом жанре.
select count(a.artist_id) as quantity, g.name from artistsgenre a
left join genre g on a.genre_id = g.id
group by artist_id , g.name

--Количество треков, вошедших в альбомы 2019–2020 годов.
select count(s.album_id) from songs s
join albums a on s.album_id = a.id 
where a.realease_date between '01-01-2019' and '31-12-2020'

--Средняя продолжительность треков по каждому альбому.
select avg(s.duration), a.name from songs s
left join albums a on s.album_id = a.id
group by a.name

--Все исполнители, которые не выпустили альбомы в 2020 году.
select distinct ar.name from artists ar
where ar.name not in (select distinct ar.name from artists ar
left join artistsalbums a on a.artist_id = ar.id
left join albums al on a.album_id = al.id
where al.realease_date between '01-01-2020' and '31-12-2020')


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