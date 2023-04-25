-- ===================== ĐÁNH GIÁ CHẤT LƯỢNG KIẾN THỨC THỰC HÀNH NÂNG CAO MODULE 04 –MYSQL– HACKATHON 01-JV11 =====================

-- ===================== CREATE DATABSE =====================
create database QLBH_Mai_Anh_Khoa;
use QLBH_Mai_Anh_Khoa;

-- ===================== CREATE DATABSE =====================
create table Customer (
cID int primary key,
`cName` VarChar (25),
cAge tinyint
);

create table `Order` (
oID int primary key,
cID int,
oDate Datetime,
oTotalPrice int,
foreign key (cID) references Customer(cID)
);

create table Product (
pID int primary key,
pName varchar(25),
pPrice int
);

create table OrderDetail (
oID int,
pID int,
odQTY int,
foreign key (oID) references `Order`(oID),
foreign key (pID) references Product(pID)
);

-- ===================== INSERT INTO TABLE =====================
insert into Customer values 
(1, "Minh Quan", 10),
(2, "Ngoc Oanh", 20),
(3, "Hong Ha", 50);

insert into `Order`(oID, cID, oDate) values 
(1, 1, "2006-03-21"),
(2, 2, "2006-03-23"),
(3, 1, "2006-03-16");

insert into Product values 
(1, "May Giat", 3),
(2, "Tu Lanh", 5),
(3, "Dieu Hoa", 7),
(4, "Quat", 1),
(5, "Bep Dien", 2);

insert into OrderDetail values 
(1, 1, 3),
(1, 3, 7),
(1, 4, 2),
(2, 1, 1),
(3, 1, 8),
(2, 5, 4),
(2, 3, 3);

-- ===================== QUERY TABLE =====================
-- 2. Hiển thị các thông tin gồm oID, oDate, oPrice của tất cả các hóa đơn 
-- trong bảng Order, danh sách phải sắp xếp theo thứ tự ngày tháng, hóa
-- đơn mới hơn nằm trên như hình:
select oID, cID, oDate, oTotalPrice from `Order` order by oDate desc;

-- 3. Hiển thị tên và giá của các sản phẩm có giá cao nhất như sau:
select pName, pPrice from Product where pPrice = (select max(pPrice) from Product);

-- 4. Hiển thị danh sách các khách hàng đã mua hàng, và danh sách sản phẩm được mua bởi các khách đó như sau:
select Customer.cName, Product.pName from Customer 
join `Order` on Customer.cID = `Order`.cID 
join OrderDetail on `Order`.oID = OrderDetail.oID
join Product on OrderDetail.pID = Product.pID;

-- 5. Hiển thị tên những khách hàng không mua bất kỳ một sản phẩm nào như sau:
select cName from Customer where cID not in (select cID from `Order`);

-- 6. Hiển thị chi tiết của từng hóa đơn như sau:
select `Order`.oID, `Order`.oDate, OrderDetail.odQTY, Product.pName, product.pPrice from `Order` 
join OrderDetail on `Order`.oID = OrderDetail.oID
join Product on OrderDetail.pID = Product.pID order by `Order`.oID;

-- 7. Hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn (giá một hóa đơn được tính bằng tổng 
-- giá bán của từng loại mặt hàng xuất hiệntrong hóa đơn. Giá bán của từng loại được tính = odQTY*pPrice) như sau:
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
select `Order`.oID, `Order`.oDate, sum(OrderDetail.odQTY * product.pPrice) as Total from `Order` 
join OrderDetail on `Order`.oID = OrderDetail.oID
join Product on OrderDetail.pID = Product.pID
group by `Order`.oID;

-- 8. Tạo một view tên là Sales để hiển thị tổng doanh thu của siêu thị như sau:
create view Sales as select sum(OrderDetail.odQTY * product.pPrice) as Sales from `Order` 
join OrderDetail on `Order`.oID = OrderDetail.oID
join Product on OrderDetail.pID = Product.pID;

-- 9. Xóa tất cả các ràng buộc khóa ngoại, khóa chính của tất cả các bảng:
alter table `order` drop constraint order_ibfk_1;
alter table orderdetail drop constraint orderdetail_ibfk_1, drop constraint orderdetail_ibfk_2;
alter table customer drop primary key; 
alter table `order` drop primary key; 
alter table product drop primary key; 

--  10. Tạo một trigger tên là cusUpdate trên bảng Customer, sao cho khi sửa mã khách (cID) thì mã khách
--  trong bảng Order cũng được sửa theo:

create trigger cusUpdate 
after update on Customer
for each row 
update `Order` set cID = new.cID where cID = old.cID;

-- 11. Tạo một stored procedure tên là delProduct nhận vào 1 tham số là tên của
-- một sản phẩm, strored procedure này sẽ xóa sản phẩm có tên được truyên
-- vào thông qua tham số, và các thông tin liên quan đến sản phẩm đó ở trong
-- bảng OrderDetail: 

DELIMITER //
CREATE PROCEDURE delProduct(in delPName varchar(25))
begin
delete from OrderDetail where pID = (select pID from product where pName = delPName);
delete from product  where pName = delPName;
end //
DELIMITER ;


-- ============================================================== END ==============================================================

