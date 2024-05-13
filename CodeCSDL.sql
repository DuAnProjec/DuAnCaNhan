-- SYNONYM
/* 1. Tạo tên đồng nghĩa cho bảng Nhân Viên.*/
create synonym NV
for dbo.NhanVien

-- kiểm thử
select *
from NV

/* 2. Tạo tên đồng nghĩa cho bảng Khách Hàng.*/
create synonym KH
for dbo.KhachHang

-- kiểm thử
select *
from KH

/* 3. Tạo tên đồng nghĩa cho bảng Phiếu Nhập.*/
create synonym PN
for dbo.PhieuNhap

-- kiểm thử
select *
from PN

-- INDEX
/* 1. Tạo chỉ mục có tên ind_TenKH_KH trên cột TenKH của bảng Khách Hàng.*/
create index ind_TenKH_KH
on KhachHang(TenKH)

-- kiểm thử 
select *
from KhachHang
where TenKH = N'Quốc Bảo'

/* 2. Tạo chỉ mục có tên ind_TenMH_MH trên cột TenMH của bảng Mặt Hàng.*/
create index ind_TenMH_MH
on MatHang(TenMH)

-- kiểm thử  
select *
from MatHang
where TenMH = N'Sữa ông thọ'

/* 3. Tạo chỉ mục có tên ind_TenCV_CV trên cột MaCV của bảng Chức Vụ.*/
create index ind_TenCV_CV
on ChucVu(TenCV)

-- kiểm thử   
select *
from ChucVu
where MaCV='NS'

-- VIEW
/* 1. Tạo view vwNhanVien với các thông tin: Mã nhân viên, họ nhân viên, tên nhân viên, mã chức vụ, 
tên chức vụ, giới tính, địa chỉ.*/
create view vwNhanVien
as
select MaNV, HoNV+' '+TenNV as HoTenNV, NV.MaCV, TenCV, GioiTinh, DiaChi
from NhanVien NV join ChucVu CV on NV.MaCV=CV.MaCV

-- kiểm thử 
select *
from vwNhanVien

/* 2. Tạo view vwGDQA với các thông tin: Mã mặt hàng, tên mặt hàng, Số lượng, Đơn giá nhập, Tên loại hàng
của các mặt hàng thuộc loại Quần áo hoặc Giày dép.*/
create view vwGDQA
as
select MH.MaMH, TenMH, SoLuong, DonGiaNhap, TenLoaiHang
from MatHang MH join
	 LoaiHang LH on MH.MaLoaiHang=LH.MaLoaiHang join
	 CTPhieuNhap CTPN on MH.MaMH=CTPN.MaMH
where TenLoaiHang like N'Giày dép' or TenLoaiHang like N'Quần áo'

-- kiểm thử
select *
from vwGDQA

/* 3. Tạo view vwDsNCC liệt kê danh sách nhà cung cấp không giao dịch mua bán với cửa hàng trong quý 1/2023, 
gồm thông tin: mã nhà cung cấp, tên nhà cung cấp, địa chỉ, số điện thoại.*/
create view vwDsNCC
as
select MaNCC, TenNCC, Diachi, Dienthoai
from NhaCungCap
where MaNCC not in(select MaNCC
				   from PhieuNhap
				   where month(Ngaynhap) in (1,2,3) and year(Ngaynhap)=2023)

-- kiểm thử
select *
from vwDsNCC

/* 4. Tạo view vwTriGiaHoaDon cho biết tổng trị giá hóa đơn với các thông tin: Mã hóa đơn, mã khách hàng, 
mã nhân viên, tổng tiền hóa đơn.*/
create view vwTriGiaHoaDon
as
select HD.MaHD, MaKH, MaNV, sum(SLDat*DgBan) as TongTien
from HoaDon HD join CTHoaDon CTHD on HD.MaHD=CTHD.MaHD
group by HD.MaHD, MaKH, MaNV

-- kiểm thử 
select *
from vwTriGiaHoaDon

/* 5. Tạo view vwTriGiaHoaDonmax cho biết khách hàng nào có hóa đơn mà tổng trị giá hóa đơn lớn nhất với các thông tin: 
Mã khách hàng, mã hóa đơn, họ tên khách hàng, giới tính, SDT, tổng trị giá hóa đơn.*/
create view vwTriGiaHoaDonmax
as
select KH.MaKH, HD.MaHD, HoKH+' '+TenKH as HoTenKH, GioiTinh, SoDT, sum(SLDat*DgBan) as TongTriGiaHD
from HoaDon HD join
	 CTHoaDon CTHD on HD.MaHD=CTHD.MaHD join
	 KhachHang KH on HD.MaKH=KH.MaKH
group by KH.MaKH, HD.MaHD, HoKH+' '+TenKH , GioiTinh, SoDT
having sum(SLDat*DgBan)= (select top(1) sum(SLDat*DgBan)
						  from HoaDon HD join
							   CTHoaDon CTHD on HD.MaHD=CTHD.MaHD join
							   KhachHang KH on HD.MaKH=KH.MaKH
						  group by KH.MaKH, HD.MaHD, HoKH+' '+TenKH , GioiTinh, SoDT
						  order by sum(SLDat*DgBan) desc)

-- kiểm thử 
select *
from vwTriGiaHoaDonmax

-- STORED PROCEDURE
/* 1. Cho biết danh sách 3 hóa đơn có trị giá bán lớn nhất.*/
create proc sp_xemtop3trigiaban
as
select MaHD, MaMH, SLDat*DgBan as DonGiaBan
from CTHoaDon
where SLDat*DgBan in (select top(3) SLDat*DgBan
					  from CTHoaDon
					  order by SLDat*DgBan desc)

-- kiểm thử 
exec sp_xemtop3trigiaban

/* 2. Xem thông tin hóa đơn gồm có: mã hóa đơn, mã nhân viên, họ tên nhân viên, mã khách hàng, 
họ tên khách hàng, ngày hóa đơn với mã khách hàng do người dùng yêu cầu.*/  
create proc sp_thongtinhoadon @MaKH nchar(6)
as
select HD.MaHD, NV.MaNV, HoNV+' '+TenNV as HoTenNV,KH.MaKH,  HoKH+' '+TenKH as HoTenKH, NgayDH
from HoaDon HD join
	 KhachHang KH on HD.MaKH=KH.MaKH join
	 NhanVien NV on HD.MaNV=NV.MaNV
where KH.MaKH=@MaKH

-- kiểm thử 
exec sp_thongtinhoadon 'KH0012'

/* 3. Xem thông tin đơn hàng gồm mã hóa đơn, mã hàng, tên hàng, số lượng bán, đơn giá bán theo khoảng thời gian 
từ ngày đến ngày do người dùng yêu cầu.*/
create proc sp_thongtinhoadon5 @tungay datetime, @denngay datetime
as
select HD.MaHD,MH.MaMH, TenMH, SlDat, CTHD.DgBan
from HoaDon HD join
	 CTHoaDon CTHD on HD.MaHD=CTHD.MaHD join
	 MatHang MH on CTHD.MaMH=MH.MaMH
where NgayDH>=@tungay and NgayDH<=@denngay

-- kiểm thử 
exec sp_thongtinhoadon5 '2022/04/01', '2022/04/05'

/* 4. Xem thông tin khách hàng với mã khách hàng do người dùng nhập.*/
create proc sp_xemkhachhang @MaKH nchar(6)
as
select *
from KhachHang
where MaKH=@MaKH

-- kiểm thử 
exec sp_xemkhachhang 'KH0001'

/* 5. Xem thông tin hóa đơn gồm có: mã hóa đơn, mã nhân viên, họ tên nhân viên, mã khách hàng, 
họ tên khách hàng, ngày hóa đơn với ngày hóa đơn do người dùng yêu cầu.*/
create proc sp_thongtinhoadon4 @Ngay int, @Thang int, @nam int
as
select HD.MaHD, NV.MaNV, HoNV+' '+TenNV as HoTenNV,KH.MaKH,  HoKH+' '+TenKH as HoTenKH, NgayDH
from HoaDon HD join
	 KhachHang KH on HD.MaKH=KH.MaKH join
	 NhanVien NV on HD.MaNV=NV.MaNV
where day(NgayDH)=@Ngay and month(NgayDH)=@Thang and year(NgayDH)=@nam

-- kiểm thử
exec sp_thongtinhoadon4 5, 4, 2022

/* 6. Cho biết doanh thu bán hàng với tháng và năm tham số truyền vào và doanh thu là tham số truyền ra.*/
create proc sp_doanhthutheothang @thang int, @nam int, @doanhthu int output
as
select @doanhthu= sum(SLDat*DgBan)
from CTHoaDon CTHD join HoaDon HD on CTHD.MaHD=HD.MaHD
where month(NgayDH)=@thang and year(NgayDH)=@nam

-- kiểm thử
declare @doanhthu int
set @doanhthu=0
exec sp_doanhthutheothang 4,2022, @doanhthu output
print N'Doanh thu theo tháng 4/2022 là: ' +cast(@doanhthu as nvarchar(10))

-- FUNCTION
/* 1. Tạo hàm xem danh sách các mặt hàng theo loại hàng (trả về dạng bảng)*/
create function f_xemdanhsachmathang(@Maloaihang nchar(6))
returns table
as
return (select *
		from MatHang
		where MaLoaiHang=@Maloaihang)

-- kiểm thử 
select *
from dbo.f_xemdanhsachmathang('DU01')

/* 2. Tạo hàm cho biết trong từng hóa đơn có bao nhiêu mặt hàng với tham số truyền vào là Mã hóa đơn.*/
create function f_sohanghoa(@MaHD nchar(6))
returns int
as
begin
declare @MaMH int
select @MaMH=count(MaMH)
from CTHoaDon
where MaHD=@MaHD
return @MaMH
end

-- kiểm thử 
select dbo.f_sohanghoa('S00002') as TongSoHangHoa

/* 3. Tạo hàm cho biết tổng số lượng hàng trong hóa đơn với tham số truyền vào là mã hóa đơn.*/
create function f_seensoluonghang3(@MaHD nchar(6))
returns int
as
begin 
declare @Soluonghang int
select @Soluonghang=sum(SLDat)
from CTHoaDon CTHD join
	 HoaDon HD on CTHD.MaHD=HD.MaHD join
	 NhanVien NV on HD.MaNV=NV.MaNV join
	 KhachHang KH on HD.MaKH=KH.MaKH
where HD.MaHD=@MaHD
return @Soluonghang
end

-- kiểm thử 
select dbo.f_seensoluonghang3('S00001') as TongSoLuongHang

/* 4. Tạo hàm cho biết số lượng đơn đặt hàng theo từng khách hàng (gồm thông tin 
Mã khách hàng, Họ tên khách hàng, Số lượng đơn đặt hàng).*/
create function f_soluongddh2()
returns table
as
return (select KH.MaKH, HoKH+' '+TenKH as HoTenNV, count(MaHD) as Soluongddh
		from HoaDon HD join KhachHang KH on HD.MaKH=KH.MaKH
		group by  KH.MaKH, HoKH+' '+TenKH)

-- kiểm thử 
select *
from f_soluongddh2()

-- TRIGGER
/* 1. Giới tính nhân viên có giá trị Nam hoặc Nữ.*/
create trigger tg_nhanvien
on NhanVien
for insert, update
as
if exists (select *
		   from inserted
		   where inserted.GioiTinh!=N'Nữ' and inserted.GioiTinh!='Nam')
	begin
		print(N'Gioi tinh co gia tri Nam hoac Nu')
		rollback tran
	end

-- kiểm thử thành công
insert into NhanVien values ('NV0022','MK',N'Lê Phạm',N'Bích Tuyền',N'Nữ',N'Ngô Văn Tự,Quận 6',convert (datetime,'5/4/1989'),'0665623526',null,convert(datetime,'6/25/2020'))

-- kiểm thử bị lỗi
insert into NhanVien values ('NV0023','MK',N'Nguyễn ',N'Minh Thành','NNamm',N'Ngô Văn Tự,Quận 6',convert (datetime,'5/4/1989'),'0665623526',null,convert(datetime,'6/25/2020'))


/* 2. Ngày dự kiến nhận hàng phải lớn hơn hoặc bằng ngày đặt hàng.*/
create trigger tg_ngaydukien
on HoaDon
for insert, update
as
if exists (select *
		   from inserted
		   where inserted.NgayDKNH<inserted.NgayDH)
	begin
		print(N'Ngay du kien nhan hang phai lon hon hoac bang ngay dat hang')
		rollback tran
	end

-- kiểm thử thành công
update HoaDon
set NgayDH='2022/05/01'
where MaHD='S00001'

-- kiểm thử bị lỗi
update HoaDon
set NgayDH='2022/06/09'
where MaHD='S00001'

/* 3. Đơn giá nhập của bảng CTPhieuNhap phải nhỏ hơn đơn giá bán của bảng CTPhieuXuat.*/
create trigger tg_dongia
on CTPhieuNhap
for insert, update
as
if exists (select * 
		   from inserted join CTPhieuXuat on inserted.MaMH=CTPhieuXuat.MaMH
		   where inserted.DonGiaNhap>=CTPhieuXuat.DonGiaBan)
	begin
		print(N'Don gia nhap phai nho hon don gia ban')
		rollback tran
	end

-- kiểm thử thành công
update CTPhieuNhap 
set DonGiaNhap=20000
where MaMH='MH03'

-- kiểm thử bị lỗi
update CTPhieuNhap 
set DonGiaNhap=500000
where MaMH='MH03'

-- USER
-- Tài khoản dành cho ADMIN
--Tạo tài khoản
create login da
with password= '03022003',
default_database= QuanLyBanHangBigC

-- tạo người dùng
create user da
for login da

-- cấp quyền
grant select, insert, update, delete
to da

-- Tài khoản dành cho Nhân Viên
-- Tạo tài khoản
create login m_an
with password= '10082003',
default_database= QuanLyBanHangBigC

-- tạo người dùng
create user m_an
for login m_an

-- cấp quyền
grant insert, update, select
on KhachHang
to m_an

-- Từ chối quyền
deny update 
on KhachHang
to m_an

-- Thu hồi quyền
revoke select on KhachHang to an

-- xóa người dùng
drop user da
drop user m_an
