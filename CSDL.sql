--Tạo CSDL
create database QuanLyBanHangBigC
go

--Chọn CSDL
use QuanLyBanHangBigC
go

-- 1.Tạo bảng khách hàng
CREATE TABLE KhachHang (
	MaKH	nchar(6) primary key, 
	HoKH	nvarchar(30) not null,
	TenKH	nvarchar(30) not null, 
	GioiTinh nvarchar(10) not null,
	DiaChi	nvarchar(100), 
	SoDT	nvarchar(15) not null	
)
go

-- 2.Tạo bảng Chức Vụ
CREATE TABLE ChucVu ( 
	MaCV nchar(6) primary key, 
	TenCV nvarchar(50) 
)
go

--3. Tạo bảng nhân viên
CREATE TABLE NhanVien ( 
	MaNV nchar(6) primary key, 
	MaCV nchar(6) foreign key references ChucVu(MaCV), 
	HoNV nvarchar(30) not null, 
	TenNV nvarchar(30) not null, 
	GioiTinh nvarchar(6) not null, 
	DiaChi nvarchar(100) not null, 
	NgaySinh datetime not null, 
	DienThoai nvarchar(15), 
	Email nvarchar(100), 
	NgayVaoLam datetime not null 
)
go

--4. Tạo bảng nhà cung cấp
CREATE TABLE NhaCungCap ( 
	MaNCC nchar(6) primary key, 
	TenNCC nvarchar(50) not null, 
	DiaChi nvarchar(50) not null,
	DienThoai nvarchar(15) not null,
	Email nvarchar(30) 
)
go

--5. Tạo bảng loại hàng
CREATE TABLE LoaiHang ( 
	MaLoaiHang nchar(6) primary key, 
	TenLoaiHang nvarchar(30) not null,
	GhiChu text --Sửa lại word
)
go

--6. Tạo bảng mặt hàng
CREATE TABLE MatHang ( 
	MaMH nchar(6) primary key, 
	MaLoaiHang nchar(6) foreign key references LoaiHang(MaLoaiHang), 
	TenMH nvarchar(50) not null, 
	DonViTinh nvarchar(10) not null, 
	GhiChu text --Sửa lại word
)
go

--7. Tạo bảng phiếu nhập
CREATE TABLE PhieuNhap ( 
	SoPN nchar(6) primary key, 
	MaNV nchar(6) foreign key references NhanVien(MaNV), 
	MaNCC nchar(6) foreign key references NhaCungCap(MaNCC), 
	NgayNhap datetime not null, 
	GhiChu text
)
go

--8. Tạo bảng chi tiết phiếu nhập
CREATE TABLE CTPhieuNhap ( 
	MaMH	nchar(6), 
	SoPN	nchar(6), 
	SoLuong	    smallint not null,
	DonGiaNhap	real not null,
	primary key (MaMH,SoPN),
	foreign key (MaMH) references MatHang(MaMH),
	foreign key (SoPN) references PhieuNhap(SoPN)
)
go

--9. Tạo bảng phiếu xuất
CREATE TABLE PhieuXuat ( 
	SoPX nchar(6) not null, 
	MaNV nchar(6), 
	MaKH nchar(6), 
	NgayXuat datetime not null, 
	GhiChu ntext, 
	PRIMARY KEY (SoPX), 
	foreign key (MaKH) references KhachHang(MaKH),
	foreign key (MaNV) references NhanVien(MaNV)
)
go

--10. Tạo bảng chi tiết phiếu xuất
CREATE TABLE CTPhieuXuat ( 
		SoPX nchar(6), 
		MaMH nchar(6), 
		SoLuong smallint not null, 
		DonGiaBan float not null,
		primary key (SoPX,MaMH),
		foreign key (SoPX) references PhieuXuat(SoPX),
		foreign key (MaMH) references MatHang(MaMH)
)
go

-- 11.Tạo bảng hóa đơn
CREATE TABLE HoaDon (
	MaHD nchar (6) primary key, 
	MaKH nchar(6) foreign key references KhachHang(MaKH), 
	MaNV nchar (6) foreign key references NhanVien(MaNV), 
	NgayDH datetime not null,
	NgayDKNH datetime not null,
	PTTT nvarchar (100)
)
go

--12. Tạo bảng Chi tiết hóa đơn
CREATE TABLE CTHoaDon ( 
	MaHD nchar (6), 
	MaMH nchar (6), 
	SLDat int not null,
	DgBan float not null,
	primary key (MaHD, MaMH),
	foreign key (MaHD) references HoaDon (MaHD),
	foreign key (MaMH) references MatHang(MaMH)
)
go

-- 13. tạo bảng Thẻ thành viên
CREATE TABLE TheThanhVien ( 
	MaThe nchar(6) primary key, 
	MaKH nchar(6) foreign key references KhachHang(MaKH), 
	LoaiThe nvarchar(10) not null,
	NgayDK datetime not null
)
go

-- 14. tạo chi nhánh
CREATE TABLE ChiNhanh ( 
	MaCN nchar(6) primary key, 
	DiaChiCN nvarchar(100) not null, 
	MaNV nchar(6) foreign key references NhanVien(MaNV) 
)
go

-- tạo dữ liệu
--1. Dữ liệu bảng Khách Hàng
insert into KhachHang values ('KH0001',N'Trần Duy',N'Bảo',N'Nam',N'D1/6, đường 385,p. Tăng Nhơn Phú A, Tp. Thủ Đức, TPHCM','0823039778')
insert into KhachHang values ('KH0002',N'Trương',N'Thị Phượng',N'Nữ',N'S202 Vinhomes Grand Park, phường Long Thạnh Mỹ, Q9, TPHCM','0852852386')
insert into KhachHang values ('KH0003',N'Đoàn',N'Công Khải',N'Nam',N'247 đường Tây Thạnh, P. Tây Thạnh, Q. Tân Phú, TPHCM','0939595299')
insert into KhachHang values ('KH0004',N'Trần Thị',N'Cẩm Ly',N'Nữ',N'64 Cao Lỗ, P.4, Q.8, TPHCM','0968449889')
insert into KhachHang values ('KH0005',N'Mạch',N'Ngọc Thủy',N'Nữ',N'1 Sương Nguyệt Ánh, P. Bến Thành, Q.1, TPHCM','0933927666')
insert into KhachHang values ('KH0006',N'Trần',N'Bảo Lộc',N'Nữ',N'1146 Phạm Văn Đồng, P. Linh Đông, Q. Thủ Đức, TPHCM','090363945')
insert into KhachHang values ('KH0007',N'Nguyễn',N'Bảo Khang',N'Nam',N'Tầng 1, Tòa nhà Packsimex, 52 Đông Du, P. Bến Nghé, Q.1, TPHCM','0909672222')
insert into KhachHang values ('KH0008',N'Đặng',N'Quốc Bảo',N'Nam',N'725B Đỗ Xuân Hợp, P. Phú Hữu, Q.9, TPHCM','0938699515')
insert into KhachHang values ('KH0009',N'Hồ Hoàng',N'Kim Tú',N'Nữ',N'62 Kênh Nước Đen, P. Bình Hưng Hoà A, Q. Bình Tân, TPHCM',' 0963321739')
insert into KhachHang values ('KH0010',N'Hồ Thị',N'Phương Thảo',N'Nữ',N'488 Tỉnh Lộ 8, Phước Vĩnh An, Củ Chi, TPHCM','0933795255')
insert into KhachHang values ('KH0011',N'Nguyễn',N'Thủy Tú',N'Nữ',N'394/35 Âu Cơ, P.10, Q. Tân Bình, TPHCM','0987447766')
insert into KhachHang values ('KH0012',N'Trương Thị',N'Bích Thùy',N'Nữ',N'C30 Bắc Hải, P.6, Q.10, TPHCM',' 0939177123')
insert into KhachHang values ('KH0013',N'Phạm',N'Ngọc Trình',N'Nam',N'196 Nguyễn Thị Định, P. An Phú, Q.2, TPHCM','0971356662')
insert into KhachHang values ('KH0014',N'Lê',N'Bích Ngà',N'Nữ',N'20/5 Khu Phố 2, Đường Tô Ký, P. Tân Chánh Hiệp, Q.12, TPHCM','0979448327')
insert into KhachHang values ('KH0015',N'Trần',N'Hữu Khang',N'Nam',N'61/1 Quốc Lộ 22, Ấp Bàu Tre 2, Xã Tân An Hội, Củ Chi, TPHCM','0938920089')
insert into KhachHang values ('KH0016',N'Nguyễn',N'Quốc Thanh',N'Nam',N'6-8 Đoàn Văn Bơ, P. 9, Q.4, TPHCM','0939434861')
insert into KhachHang values ('KH0017',N'Lâm Hoàng',N'Trúc Mai',N'Nữ',N'44A Đường số 8, P. Tam Phú, Thủ Đức, TPHCM','0936616186')
insert into KhachHang values ('KH0018',N'Bùi',N'Cẩm Loan',N'Nữ',N'171-171A An Phú Đông 3, Tổ 40, Khu phố 5, P. An Phú Đông, Q.12, TPHCM','0901180094')
insert into KhachHang values ('KH0019',N'Nguyễn',N'Hữu Thắng',N'Nam',N'Toà Nhà Thăng Long Vina, 371 Nguyễn Kiệm, P.3, Q. Gò Vấp, TPHCM','0372383838')
insert into KhachHang values ('KH0020',N'Trần' ,N'Bá Lộc',N'Nam',N'B1/24D, Ấp 2, Xã Vĩnh Lộc B, Huyện Bình Chánh, TPHCM','0975448499')

--2. Dữ liệu bảng Chức Vụ
insert into ChucVu values ('GĐ',N'Giám đốc')
insert into ChucVu values ('PGĐ',N'Phó giám đốc')
insert into ChucVu values ('QLBH',N'Quản lý bộ phận bán hàng')
insert into ChucVu values ('TPNS',N'Trưởng phòng nhân sự')
insert into ChucVu values ('BH',N'Nhân viên bán hàng')
insert into ChucVu values ('TVKH',N'Nhân viên tư vấn khách hàng')
insert into ChucVu values ('KK',N'Kiểm kê')
insert into ChucVu values ('NS',N'Nhân viên phòng nhân sự') 
insert into ChucVu values ('MK',N'Nhân viên phòng Marketing') 

--3. Dữ liệu bảng Nhân Viên
insert into NhanVien values ('NV0001','GĐ',N'Đỗ Thị',N'Linh Đa',N'Nữ',N'B2/1A,Tăng Nhơn Phú A,TP.Thủ Đức',convert (datetime,'2/3/2003'),'0329321534',null,convert(datetime,'4/6/2015'))
insert into NhanVien values ('NV0002','PGĐ',N'Nguyễn',N'Minh An',N'Nam',N'B2/1A,Tăng Nhơn Phú A,TP.Thủ Đức',convert (datetime,'10/8/2003'),'0399525028',null,convert(datetime,'7/4/2015'))
insert into NhanVien values ('NV0003','QLBH',N'Nguyễn',N'Nhật Tâm',N'Nam',N'D2/3, Võ Văn Hát,TP.Thủ Đức',convert (datetime,'6/6/1990'),'0396543678','tam@gmail.com',convert(datetime,'12/26/2016'))
insert into NhanVien values ('NV0004','TVKH',N'Hà Thị',N'Trúc Mai',N'Nữ',N'B1/285 Hồ Thị Kỹ,Quận Gò Vấp',convert (datetime,'4/5/1989'),'0234689245','mai@gmail.com',convert(datetime,'12/13/2016'))
insert into NhanVien values ('NV0005','NS',N'Nguyễn',N'Nhất Linh',N'Nam',N'D2/13,Đường Lê Văn Việt,Tăng Nhơn Phú A,TP.Thủ Đức',convert (datetime,'4/7/2000'),'0396782652',null,convert(datetime,'1/24/2016'))
insert into NhanVien values ('NV0006','TPNS',N'Đào Thị',N'Thanh Trúc',N'Nữ',N'D4/32 Hồ Thị Tư,TP.Thủ Đức',convert (datetime,'8/8/1992'),'0326578956','truc@gmail.com',convert(datetime,'5/16/2015'))
insert into NhanVien values ('NV0007','KK',N'Huỳnh Thị',N'Ngọc Giang',N'Nữ',N'Dĩ An,Bình Dương',convert (datetime,'8/4/1995'),'0378542695','giang@gmail.com',convert(datetime,'3/16/2017'))
insert into NhanVien values ('NV0008','QLBH',N'Lê',N'Hoài Ngọc',N'Nữ',N'Hồ Con Rùa,Quận 3',convert (datetime,'5/5/2000'),'0342569874','ngoc@gmail.com',convert(datetime,'3/8/2016'))
insert into NhanVien values ('NV0009','TVKH',N'Hồ',N'Ngọc Hà',N'Nữ',N'Phạm Văn Đồng,Quận Gò Vấp',convert (datetime,'9/12/1996'),'0145263789',null,convert(datetime,'12/14/2022'))
insert into NhanVien values ('NV0010','KK',N'Nguyễn',N'Quốc Bảo',N'Nam',N'Phan Đức Thọ,Quận Gò Vấp',convert (datetime,'5/4/1989'),'0396536748',null,convert(datetime,'3/11/2016'))
insert into NhanVien values ('NV0011','BH',N'Nguyễn Hồ',N'Phương Thảo',N'Nữ',N'Nguyễn Kiệm,Quận Gò Vấp',convert (datetime,'7/8/1990'),'0396785436','thao@gmail.com',convert(datetime,'02/03/2017'))
insert into NhanVien values ('NV0012','KK',N'Đặng',N'Nhất Hoài',N'Nam',N'Nguyễn Tri Phương,Quận 1',convert (datetime,'5/4/1989'),'0343678965','hoai@gmail.com',convert(datetime,'07/13/2016'))
insert into NhanVien values ('NV0013','MK',N'Nguyễn',N'Bảo Linh',N'Nam',N'Đa Khao,Quận 1',convert (datetime,'9/11/1992'),'0397836546','linh@gmail.com',convert(datetime,'04/05/2019'))
insert into NhanVien values ('NV0014','QLBH',N'Nguyễn',N'Chí Thanh',N'Nam',N'Thủ dầu một,Bình Dương',convert (datetime,'12/7/1994'),'0365325266','thanh@gmail.com',convert(datetime,'06/08/2016'))
insert into NhanVien values ('NV0015','TVKH',N'Võ Thị',N'Thu Thảo',N'Nữ',N'Long Bình,Tăng Nhơn Phú B,TP.Thủ Đức',convert (datetime,'8/10/1992'),'0326933527',null,convert(datetime,'02/01/2019'))
insert into NhanVien values ('NV0016','TVKH',N'Võ',N'Hạ Linh',N'Nữ',N'Dĩ an,TP.Thủ Đức',convert (datetime,'10/9/1997'),'0266535236','linh@gmail.com',convert(datetime,'09/01/2020'))
insert into NhanVien values ('NV0017','BH',N'Đặng',N'Minh Mẫn',N'Nam',N'Điện biên phủ,Quận Gò Vấp',convert (datetime,'7/8/1992'),'0366552623',null,convert(datetime,'07/09/1997'))
insert into NhanVien values ('NV0018','MK',N'Ngô',N'Thanh Bình',N'Nam',N'Âu Cơ,Trường Chinh,Tân Bình',convert (datetime,'7/10/1991'),'0665235362','binh@gmail.com',convert(datetime,'09/09/2021'))
insert into NhanVien values ('NV0019','NS',N'Lê Ngọc',N'Nhật Lệ',N'Nữ',N'Lã Xuân Oai,TP.Thủ Đức',convert (datetime,'5/3/1994'),'0635266562',null,convert(datetime,'5/19/2019'))
insert into NhanVien values ('NV0020','TVKH',N'Lê Thị',N'Bích Ngà',N'Nữ',N'Ngô Văn Tự,Quận 6',convert (datetime,'5/4/1989'),'0665623526',null,convert(datetime,'6/25/2020'))

--4. Dữ liệu bảng Nhà Cung Cấp
insert into NhaCungCap values (N'NCC01', N'Công ty cổ phần Việt Tiến', N'07 Lê Minh Xuân - Q. Tân Bình - TP Hồ Chí Minh', N'0838640800', N'vtec@hcm.vnn.vn')
insert into NhaCungCap values (N'NCC02', N'Công ty cổ phần 32', N'06 Trần Minh Tuấn - Q. Tân Bình - TP Hồ Chí Minh', N'0838640801', N'vtec1@hcm.vnn.vn')
insert into NhaCungCap values (N'NCC03', N'Công ty cổ phần Vì Việt Nam', N'05 Hoàng Hoa Thám - Q. Tân Bình - TP Hồ Chí Minh', N'0386440802', N'vtec2@hcm.vnn.vn')
insert into NhaCungCap values (N'NCC04', N'Vinamilk', N'10 - Tân Trào - P. Tân Phú - Q7 - TP.HCM', N'0854155555', N'vinamilk@vinamilk.com.vn')
insert into NhaCungCap values (N'NCC05', N'Tập đoàn Unilever Việt Nam', N'01 Nguyễn Thị Minh Khai - p. Tân Định - Q.1', N'0839696999', N'tuvan@unilever.com.vn')
insert into NhaCungCap values (N'NCC06', N'Công ty cổ phần Cười Cái Coi', N'04 Lê Minh Xuân - Q. Tân Bình - TP Hồ Chí Minh', N'0862954079', N'cuoicaicoi@gmail.com')
insert into NhaCungCap values (N'NCC07', N'Công ty cổ phần Quốc Cường Gia Lai', N'13 Nguyễn Thái Bình - Q.7 - TP.HCM', N'0862950403', N'qcgl@gmail.com')
insert into NhaCungCap values (N'NCC08', N'Công ty cổ phần Hoàng Anh Gia Lai', N'90 Phan Huy Ích - Q.7 - TP.HCM', N'(84) 8.39960573', N'hagl@gmail.com')
insert into NhaCungCap values (N'NCC09', N'Công ty cổ phần Acecook Việt Nam', N'11 Tân Bình - phường Tây Thạnh - quận Tân Phú', N'0838154064', N'acecookvietnam@vnn.vn')
insert into NhaCungCap values (N'NCC10', N'Công ty cổ phần Vifon Việt Nam', N'913 Trường Chinh, P. Tây Thạnh, Q. Tân Phú, Tp HCM', N'0838153933', N'ctyvifon@vifon.com.vn')

--5. Dữ liệu bảng Loại Hàng Hóa
insert into LoaiHang values (N'BG01', N'Bột giặt, nước xả', N'hóa mỹ phẩm')
insert into LoaiHang values (N'CN01', N'Đồ dùng cá nhân', N'hóa mỹ phẩm')
insert into LoaiHang values (N'DG01', N'Dầu gội, dầu xả', N'hóa mỹ phẩm')
insert into LoaiHang values (N'DH01', N'Đồ hộp', N'thực phẩm khô')
insert into LoaiHang values (N'DU01', N'Đồ uống', N'giải khát')
insert into LoaiHang values (N'GD01', N'Giày dép', N'thời trang')
insert into LoaiHang values (N'KR01', N'Kem đánh răng', N'hóa mỹ phẩm')
insert into LoaiHang values (N'QA01', N'Quần áo', N'thời trang')
insert into LoaiHang values (N'RU01', N'Rượu bia', N'giải khát')
insert into LoaiHang values (N'TN01', N'Thức ăn nhanh', N'thực phẩm khô')

--6. Dữ liệu bảng Mặt Hàng
INSERT INTO MatHang VALUES (N'MH01', N'BG01', N'Omo chai', N'chai', NULL)
INSERT INTO MatHang VALUES (N'MH02', N'CN01', N'Bàn chải colgate', N'cái', NULL)
INSERT INTO MatHang VALUES (N'MH03', N'DG01', N'X men', N'chai', NULL)
INSERT INTO MatHang VALUES (N'MH04', N'DH01', N'Sữa ông thọ', N'lon', NULL)
INSERT INTO MatHang VALUES (N'MH05', N'DU01', N'Coca - Cola chai', N'chai', NULL)
INSERT INTO MatHang VALUES (N'MH06', N'GD01', N'Dép Bitis', N'đôi', NULL)
INSERT INTO MatHang VALUES (N'MH07', N'KR01', N'Colgate 300g', N'tuýp', NULL)
INSERT INTO MatHang VALUES (N'MH08', N'QA01', N'Đồ bộ lửng', N'bộ', NULL)
INSERT INTO MatHang VALUES (N'MH09', N'RU01', N'whisky Russia', N'chai', NULL)
INSERT INTO MatHang VALUES (N'MH10', N'TN01', N'Hảo hảo', N'gói', NULL)
INSERT INTO MatHang VALUES (N'MH11', N'BG01', N'Nước xả Comfort', N'chai', NULL)
INSERT INTO MatHang VALUES (N'MH12', N'DG01', N'Sữa tắm Dove', N'chai', NULL)
INSERT INTO MatHang VALUES (N'MH13', N'DH01', N'Cá sốt cà', N'hộp', NULL)
INSERT INTO MatHang VALUES (N'MH14', N'DU01', N'Coca-Cola lon', N'lon', NULL)
INSERT INTO MatHang VALUES (N'MH15', N'GD01', N'Giày con vịt', N'đôi', NULL)
INSERT INTO MatHang VALUES (N'MH16', N'TN01', N'Hảo Hảo xào khô', N'gói', NULL)
INSERT INTO MatHang VALUES (N'MH17', N'KR01', N'PS 500g', N'tuýp', NULL)
INSERT INTO MatHang VALUES (N'MH18', N'QA01', N'Đồ bộ ngắn', N'bộ', NULL)
INSERT INTO MatHang VALUES (N'MH19', N'RU01', N'Rượu ngoại XO', N'chai', NULL)
INSERT INTO MatHang VALUES (N'MH20', N'CN01', N'Khăn mặt', N'cái', NULL)

--7. Dữ liệu bảng Phiếu Nhập
insert into PhieuNhap values (N'PN001', N'NV0004', N'NCC01', convert (datetime,'2/3/2022'), N'Nhập hàng theo đơn đặt hàng số 100')
insert into PhieuNhap values (N'PN002', N'NV0005', N'NCC03', convert (datetime,'2/14/2022'), N'Nhập hàng theo đơn đặt hàng số 101')
insert into PhieuNhap values (N'PN003', N'NV0006', N'NCC01', convert (datetime,'3/4/2022'), N'Nhập hàng theo đơn đặt hàng số 102')
insert into PhieuNhap values (N'PN004', N'NV0007', N'NCC05', convert (datetime,'3/26/2022'), N'Nhập hàng theo đơn đặt hàng số 103')
insert into PhieuNhap values (N'PN005', N'NV0008', N'NCC06', convert (datetime,'5/3/2022'), N'Nhập hàng theo đơn đặt hàng số 104')
insert into PhieuNhap values (N'PN006', N'NV0009', N'NCC07', convert (datetime,'6/9/2022'), N'Nhập hàng theo đơn đặt hàng số 105')
insert into PhieuNhap values (N'PN007', N'NV0003', N'NCC04', convert (datetime,'7/6/2022'), N'Nhập hàng theo đơn đặt hàng số 106')
insert into PhieuNhap values (N'PN008', N'NV0009', N'NCC10', convert (datetime,'12/7/2022'), N'Nhập hàng theo đơn đặt hàng số 107')
insert into PhieuNhap values (N'PN009', N'NV0010', N'NCC01', convert (datetime,'1/8/2023'), NULL)
insert into PhieuNhap values (N'PN010', N'NV0010', N'NCC10', convert (datetime,'1/4/2023'), NULL)
insert into PhieuNhap values (N'PN011', N'NV0004', N'NCC08', convert (datetime,'1/13/2023'), NULL)
insert into PhieuNhap values (N'PN012', N'NV0009', N'NCC09', convert (datetime,'2/15/2023'), NULL)
insert into PhieuNhap values (N'PN013', N'NV0012', N'NCC01', convert (datetime,'2/18/2023'), NULL)
insert into PhieuNhap values (N'PN014', N'NV0005', N'NCC03', convert (datetime,'3/1/2023'), NULL)
insert into PhieuNhap values (N'PN015', N'NV0017', N'NCC05', convert (datetime,'3/4/2023'), NULL)
insert into PhieuNhap values (N'PN016', N'NV0008', N'NCC01', convert (datetime,'3/15/2023'), N'Nhập hàng theo đơn đặt hàng số 100')
insert into PhieuNhap values (N'PN017', N'NV0007', N'NCC01', convert (datetime,'3/19/2023'), null)
insert into PhieuNhap values (N'PN018', N'NV0004', N'NCC01', convert (datetime,'4/1/2023'), null)
insert into PhieuNhap values (N'PN019', N'NV0006', N'NCC01', convert (datetime,'4/3/2023'), N'Nhập hàng theo đơn đặt hàng số 100')
insert into PhieuNhap values (N'PN020', N'NV0013', N'NCC01', convert (datetime,'2/19/2023'), null)

--8. Dữ liệu bảng Chi tiết phiếu Nhập
INSERT into CTPhieuNhap VALUES (N'MH01', N'PN003', 50, 140000)
INSERT into CTPhieuNhap VALUES (N'MH01', N'PN004', 25, 140000)
INSERT into CTPhieuNhap VALUES (N'MH01', N'PN014', 10, 140000)
INSERT into CTPhieuNhap VALUES (N'MH02', N'PN015', 15, 35000)
INSERT into CTPhieuNhap VALUES (N'MH03', N'PN004', 40, 46000)
INSERT into CTPhieuNhap VALUES (N'MH03', N'PN014', 15, 46000)
INSERT into CTPhieuNhap VALUES (N'MH04', N'PN005', 20, 20000)
INSERT into CTPhieuNhap VALUES (N'MH04', N'PN007', 90, 20000)
INSERT into CTPhieuNhap VALUES (N'MH05', N'PN001', 200, 13800)
INSERT into CTPhieuNhap VALUES (N'MH05', N'PN002', 100, 13800)
INSERT into CTPhieuNhap VALUES (N'MH06', N'PN009', 20, 235000)
INSERT into CTPhieuNhap VALUES (N'MH07', N'PN015', 10, 30000)
INSERT into CTPhieuNhap VALUES (N'MH08', N'PN001', 15, 160000)
INSERT into CTPhieuNhap VALUES (N'MH08', N'PN013', 30, 160000)
INSERT into CTPhieuNhap VALUES (N'MH10', N'PN012', 2000, 3200)
INSERT into CTPhieuNhap VALUES (N'MH12', N'PN008', 50, 61200)
INSERT into CTPhieuNhap VALUES (N'MH13', N'PN005', 56, 13200)
INSERT into CTPhieuNhap VALUES (N'MH15', N'PN006', 250, 68000)
INSERT into CTPhieuNhap VALUES (N'MH16', N'PN006', 700, 3600)
INSERT into CTPhieuNhap VALUES (N'MH18', N'PN003', 20, 90000)
INSERT into CTPhieuNhap VALUES (N'MH19', N'PN011', 10, 7400000)

--9. Dữ liệu bảng phiếu xuất
INSERT INTO PhieuXuat VALUES (N'PX001', N'NV0003', N'KH0001',convert (datetime,'2/3/2022') , NULL)
INSERT INTO PhieuXuat VALUES (N'PX002', N'NV0003', N'KH0002',convert (datetime,'2/14/2022'), NULL)
INSERT INTO PhieuXuat VALUES (N'PX003', N'NV0004', N'KH0003',convert (datetime,'3/4/2022') , NULL)
INSERT INTO PhieuXuat VALUES (N'PX004', N'NV0005', N'KH0008',convert (datetime,'3/26/2022') , NULL)
INSERT INTO PhieuXuat VALUES (N'PX005', N'NV0006', N'KH0007',convert (datetime,'5/3/2022'), NULL)
INSERT INTO PhieuXuat VALUES (N'PX006', N'NV0005', N'KH0005',convert (datetime,'6/9/2022') , NULL)
INSERT INTO PhieuXuat VALUES (N'PX007', N'NV0007', N'KH0010',convert (datetime,'7/6/2022') , NULL)
INSERT INTO PhieuXuat VALUES (N'PX008', N'NV0010', N'KH0004',convert (datetime,'1/8/2023') , NULL)
INSERT INTO PhieuXuat VALUES (N'PX009', N'NV0009', N'KH0009',convert (datetime,'1/8/2023') , NULL)
INSERT INTO PhieuXuat VALUES (N'PX010', N'NV0006', N'KH0010',convert (datetime,'3/19/2023') , NULL)
INSERT INTO PhieuXuat VALUES (N'PX011', N'NV0008', N'KH0007',convert (datetime,'3/1/2023') , NULL)
INSERT INTO PhieuXuat VALUES (N'PX012', N'NV0004', N'KH0004', convert (datetime,'2/18/2023') , NULL)
INSERT INTO PhieuXuat VALUES (N'PX013', N'NV0007', N'KH0001', convert (datetime,'4/3/2023'), NULL)
INSERT INTO PhieuXuat VALUES (N'PX014', N'NV0003', N'KH0002',convert (datetime,'12/7/2022') , NULL)
INSERT INTO PhieuXuat VALUES (N'PX015', N'NV0008', N'KH0005',convert (datetime,'2/15/2023') , NULL)

--10. Dữ liệu bảng chi tiết phiếu xuất
INSERT into CTPhieuXuat VALUES (N'PX001', N'MH01', 12, 160000)
INSERT into CTPhieuXuat VALUES (N'PX001', N'MH02', 150, 15000)
INSERT into CTPhieuXuat VALUES (N'PX002', N'MH03', 2, 50000)
INSERT into CTPhieuXuat VALUES (N'PX003', N'MH10', 20, 3600)
INSERT into CTPhieuXuat VALUES (N'PX004', N'MH07', 25, 18000)
INSERT into CTPhieuXuat VALUES (N'PX004', N'MH15', 5, 100000)
INSERT into CTPhieuXuat VALUES (N'PX005', N'MH06', 10, 250000)
INSERT into CTPhieuXuat VALUES (N'PX005', N'MH20', 16, 15000)
INSERT into CTPhieuXuat VALUES (N'PX006', N'MH01', 23, 160000)
INSERT into CTPhieuXuat VALUES (N'PX006', N'MH10', 10, 3600)
INSERT into CTPhieuXuat VALUES (N'PX007', N'MH04', 56, 26000)
INSERT into CTPhieuXuat VALUES (N'PX007', N'MH15', 3, 100000)
INSERT into CTPhieuXuat VALUES (N'PX008', N'MH02', 80, 15000)
INSERT into CTPhieuXuat VALUES (N'PX009', N'MH17', 80, 22000)
INSERT into CTPhieuXuat VALUES (N'PX010', N'MH16', 500, 5000)
INSERT into CTPhieuXuat VALUES (N'PX011', N'MH18', 7, 98000)
INSERT into CTPhieuXuat VALUES (N'PX012', N'MH19', 2, 7800000)
INSERT into CTPhieuXuat VALUES (N'PX013', N'MH01', 15, 160000)
INSERT into CTPhieuXuat VALUES (N'PX013', N'MH02', 50, 15000)
INSERT into CTPhieuXuat VALUES (N'PX014', N'MH03', 5, 50000)
INSERT into CTPhieuXuat VALUES (N'PX014', N'MH06', 10, 250000)
INSERT into CTPhieuXuat VALUES (N'PX015', N'MH02', 5, 40000)
INSERT into CTPhieuXuat VALUES (N'PX015', N'MH07', 5, 35000)

--11. Dữ liệu bảng hóa đơn
insert into HoaDon values ('S00001', 'KH0012', 'NV0003', CONVERT (datetime, '4/5/2022'), CONVERT (datetime,'6/5/2022'), N'tiền mặt')
insert into HoaDon values ('S00002','KH0013','NV0003', CONVERT (datetime,'6/5/2022'),CONVERT (datetime,'9/5/2022'),null)
insert into HoaDon values('S00003','KH0015','NV0002', CONVERT (datetime,'7/5/2022'),CONVERT (datetime,'9/5/2022'),null)
insert into HoaDon values('S00004','KH0014','NV0001', CONVERT (datetime,'8/9/2022'),CONVERT (datetime,'12/9/2022'),null)
insert into HoaDon values('S00005','KH0012','NV0002', CONVERT (datetime,'9/9/2022'),CONVERT (datetime,'10/9/2022'),null)
insert into HoaDon values('S00006','KH0013','NV0001', CONVERT (datetime,'10/9/2022'),CONVERT (datetime,'9/13/2022'),null)
insert into HoaDon values('S00007','KH0012','NV0002', CONVERT (datetime,'10/9/2022'),CONVERT (datetime,'11/9/2022'),null)
insert into HoaDon values('S00008','KH0015','NV0003', CONVERT (datetime,'10/9/2022'),CONVERT (datetime,'11/9/2022'),null)
insert into HoaDon values('S00009','KH0015','NV0001', CONVERT (datetime,'10/10/2022'),CONVERT (datetime,'12/10/2022'),null)
insert into HoaDon values('S00013','KH0012','NV0002', CONVERT (datetime,'5/4/2022'),CONVERT (datetime,'6/4/2022'),N'chuyển khoản')

--12. Dữ liệu bảng Chi tiết hóa đơn
insert into CTHoaDon values('S00001', 'MH01', 5, 16000)
insert into CTHoaDon values ('S00001', 'MH02', 5, 16000)
insert into CTHoaDon values ('S00001', 'MH09', 20, 150000)
insert into CTHoaDon values ('S00002', 'MH03', 30, 16000)
insert into CTHoaDon values ('S00002', 'MH06', 20, 55000)
insert into CTHoaDon values('S00003', 'MH02', 15, 13000)
insert into CTHoaDon values('S00003', 'MH18', 15, 18000)
insert into CTHoaDon values('S00003', 'MH15', 30, 15000)
insert into CTHoaDon values('S00004', 'MH18', 15, 160000)
insert into CTHoaDon values('S00005', 'MH13', 30, 15000)
insert into CTHoaDon values('S00006', 'MH11', 30, 16000)
insert into CTHoaDon values('S00006', 'MH10', 10, 160000)
insert into CTHoaDon values('S00006', 'MH08', 10, 54000)
insert into CTHoaDon values('S00007', 'MH04', 30, 16000)
insert into CTHoaDon values('S00007', 'MH04', 30, 160000)
insert into CTHoaDon values('S00008', 'MH05', 20, 16000)
insert into CTHoaDon values('S00008', 'MH03', 20, 57000)
insert into CTHoaDon values('S00008', 'MH07', 20, 67000)
insert into CTHoaDon values('S00009', 'MH04', 30, 16000)

--13. Dữ liệu bảng thẻ thành viên
insert into TheThanhVien values('TV0001', 'KH0001', N'Vàng',convert (datetime,'5/3/2022'))
insert into TheThanhVien values('TV0002', 'KH0005', N'Kim Cương',convert (datetime,'9/3/2022'))
insert into TheThanhVien values('TV0003', 'KH0007', N'Bạc',convert (datetime,'6/18/2022'))
insert into TheThanhVien values('TV0004', 'KH0003', N'Vàng',convert (datetime,'7/8/2022'))
insert into TheThanhVien values('TV0005', 'KH0009', N'Bạc',convert (datetime,'3/9/2022'))
insert into TheThanhVien values('TV0006', 'KH0012', N'Vàng',convert (datetime,'7/12/2022'))

--14. Dữ liệu bảng Chi nhánh
insert into ChiNhanh values('CN0001', N'Tầng B1, Khu nhà phức hợp Cantavil, An Phú, P. An Phú, Quận 2, Tp HCM', 'NV0001')
insert into ChiNhanh values('CN0002', N'Lô A, Khu Dân Cư Cityland, số 99, đường Nguyễn Thị Thập, P Tân Phú, Q 7, Tp HCM', 'NV0002')
insert into ChiNhanh values('CN0003', N'Số 12 Quốc Hương, tòa nhà Thảo Điền Pearl, P.Thảo Điền, Q.2', 'NV0009')
insert into ChiNhanh values('CN0004', N'Tầng B1, Khu nhà phức hợp Cantavil, An Phú, P. An Phú, Quận 2, Tp HCM', 'NV0013')
insert into ChiNhanh values('CN0005', N'1/1 Trường Chinh, P. Tây Thạnh, Q. Tân Phú, TP. HCM', 'NV0017')

