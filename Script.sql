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
