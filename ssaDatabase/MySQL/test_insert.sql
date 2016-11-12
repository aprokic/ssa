insert into locations
values('000000001', '539 Packard Street, Apartment 1', 'Ann Arbor', 'Michigan', '48104', 'United States');

insert into descriptions
values('000000001', '00000002', 'Living room table', 123.45);
insert into descriptions
values('000000001', '00000003', 'Living room', null);

insert into tags
values('01', '000000001', '00000002', '0000a');
insert into tags
values('00', '000000001', '00000003', '0000a');