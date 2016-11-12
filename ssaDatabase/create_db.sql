pragma foreign_keys = on;

create table locations (
	lid char(9),
	street varchar(100) not null,
	city varchar(100) not null,
	state_province_region varchar(100) not null,
	zip varchar(100) not null,
	country varchar(100) not null,
	primary key(lid),
	unique(street, city, state_province_region, zip, country)
);

create table descriptions (
	lid char(9),
	did char(8),
	description varchar(4096) not null,
	price real,
	primary key(lid, did),
	foreign key(lid) references locations(lid) on delete cascade
);

create table tags (
	type char(2),
	location char(9),
	description char(8),
	reserved char(5),
	primary key(type, location, description, reserved),
	foreign key(location) references locations(lid),
	foreign key(location, description) references descriptions(lid, did)

);

--if type is not item (tid=0) price must be null
--if type is item (tid=1) price may or may not be null
/*
create trigger insert_trigger before insert on tags
begin
select case
when (not(new.type = cast(1 as binary(10)) or (new.type = cast(0 as binary(10)) and null in (
 	select d.price from descriptions d, tags t where d.lid = t.location and d.did = t.description))))
then raise(abort, 'tag type mismatch')

end;
end;

create trigger update_trigger before update on tags
begin
select case
when (not(new.type = cast(1 as binary(10)) or (new.type = cast(0 as binary(10)) and null in (
 	select d.price from descriptions d, tags t where d.lid = t.location and d.did = t.description))))
then raise(abort, 'tag type mismatch')

end;
end;
*/
