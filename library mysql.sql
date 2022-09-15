create database library;

use library;

create table author(
  id int not null primary key auto_increment,
  first_name varchar(255),
  last_name varchar(45) not null,
  biography text
) ENGINE = InnoDB;

create table publisher(
  id int not null primary key auto_increment,
  first_name varchar(100),
  last_name varchar(100) not null,
  email varchar(45)
) ENGINE = InnoDB;

create table borrower(
  cardNo varchar(16) not null primary key,
  first_name varchar(45),
  last_name varchar(45) not null
) ENGINE = InnoDB;

create table library_branch (
  id int not null primary key auto_increment,
  name varchar(100),
  adress varchar(255)
) ENGINE = InnoDB;

create table book (
  id int not null primary key auto_increment,
  title varchar(255) not null,
  publisher_id int,
  author_id int
) ENGINE = InnoDB;

create table book_copies (
  id int not null primary key auto_increment,
  book_id int not null,
  library_branch_id int not null,
  no_of_copies int
) ENGINE = InnoDB;

create table book_loans (
  id int not null primary key auto_increment,
  library_branch_id int not null,
  borrower_cardNo varchar(16) not null,
  book_id int not null,
  date_out datetime not null,
  due_date datetime
) ENGINE = InnoDB;

alter table
  book
add
  foreign key (publisher_id) references publisher(id) on delete cascade on update cascade;

alter table
  book
add
  foreign key (author_id) references author(id) on delete cascade on update cascade;

alter table
  book_copies
add
  constraint fk_book_id foreign key (book_id) references book(id) on delete cascade;

alter table
  book_copies
add
  constraint fk_librar_branch_id foreign key (library_branch_id) references library_branch(id) on delete restrict;

alter table
  book_loans
add
  constraint fk_library_id foreign key (library_branch_id) references library_branch(id) on delete cascade;

alter table
  book_loans
add
  constraint fk_barrower_cardno foreign key(borrower_cardNo) references borrower(cardNo) on delete cascade;

load data local infile 'borrowers.csv' into table borrower fields terminated by ',' enclosed by '"' lines terminated by '\n' ignore 1 rows (cardNo, first_name, last_name);

load data local infile 'authors.csv' into table author fields terminated by ',' enclosed by '"' lines terminated by '\n' ignore 1 rows (@dummy, @first_name, @last_name)
set
  first_name = @first_name,
  last_name = @last_name;

load data local infile 'publishers.csv' into table publisher fields terminated by ',' enclosed by '"' lines terminated by '\n' ignore 1 rows (@dummy, first_name);

load data local infile 'books.csv' into table book fields terminated by ',' enclosed by '"' lines terminated by '\n' ignore 1 rows (
  @titre,
  @author,
  @editor,
  @author_last_name,
  @author_first_name
)
set
  title = @titre,
  publisher_id =(
    select
      id
    from
      publisher
    where
      first_name like concat('%', @editor, '%')
  ),
  author_id =(
    select
      id
    from
      author
    where
      first_name like concat('%', @author_last_name, '%')
      and last_name like concat('%', @author_last_name, '%')
  );