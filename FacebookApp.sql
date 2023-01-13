create database FacebookApp

use FacebookApp

create table Users(
Id int identity primary key,
Name nvarchar(50),
Surname nvarchar(50),
ProfilePhoto nvarchar(100),
Biography nvarchar(500),
PostCount int default 0
)

create table Posts(
Id int identity primary key,
Image nvarchar(100),
Text nvarchar(500),
UserId int references Users(Id)
)

create table Comments(
Id int identity primary key,
Text nvarchar(500),
PostId int references Posts(Id)
)

create trigger PostAdded
on Posts
after insert
as
begin
	update Users set PostCount =  PostCount + 1
	where Id = (select UserId from inserted Post)
end

create view ShowPostInfo as
Select Users.Name, Users.Surname, Users.ProfilePhoto, Posts.Image, Posts.Text from Posts 
left join Users
on Posts.UserId = Users.Id

select * from ShowPostInfo

create function CommentCountWithId (@UserId int) 
returns int
as
begin
	declare @CommentCount int
	select @CommentCount = Count(*) from Comments
	where Comments.PostId = (select Posts.Id from Posts where Posts.UserId = @UserId)
	return @CommentCount
end

select dbo.CommentCountWithId(1)