﻿/*
Họ và tên: Phạm Minh Hiếu
MSSV: 2011063873
Lớp: 20DTHB4
*/

-- Tạo database 
CREATE DATABASE QLTour
ON
	(NAME='QLTour_DATA',
	FILENAME='H:\BAITAP\QLTour.MDF')
LOG ON
	(NAME='QLTour_LOG',
	FILENAME='H:\BAITAP\QLTour.LDF')
GO

USE QLTour
GO

CREATE TABLE DIEMTQ
(
	MADTQ VARCHAR(3),
	TENDTQ NVARCHAR(100) NOT NULL,
	NOIDUNG NVARCHAR(100) NOT NULL,
	YNGHIA NVARCHAR(100) NOT NULL,

	CONSTRAINT PK_DIEMTQ_MADTQ PRIMARY KEY (MADTQ) 
)
GO

CREATE TABLE TOUR
(
	MATOUR VARCHAR(3),
	TENTOUR NVARCHAR(100) NOT NULL,
	SONGAY INT NOT NULL,
	SODEM INT NOT NULL,

	CONSTRAINT PK_TOUR_MATOUR PRIMARY KEY (MATOUR)
)
GO

CREATE TABLE CT_THAMQUAN
(
	MATOUR VARCHAR(3),
	MADTQ VARCHAR(3),
	THOIGIAN INT NOT NULL,

	CONSTRAINT PK_CTTHAMQUAN PRIMARY KEY (MATOUR, MADTQ),

	CONSTRAINT FK_CTTHAMQUAN_MATOUR FOREIGN KEY (MATOUR) REFERENCES TOUR(MATOUR)
	ON UPDATE CASCADE
	ON DELETE CASCADE,

	CONSTRAINT FK_CTTHAMQUAN_MADTQ FOREIGN KEY (MADTQ) REFERENCES DIEMTQ(MADTQ)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
)
GO

CREATE TABLE DOAN
(
	MADOAN VARCHAR(5),
	HOTEN NVARCHAR(30) NOT NULL,
	PHAI NVARCHAR(5) NOT NULL,
	NGAYSINH DATE NOT NULL,
	DIACHI NVARCHAR(100) NOT NULL,
	DIENTHOAI VARCHAR(11) NOT NULL,

	CONSTRAINT PK_DOAN_MADOAN PRIMARY KEY (MADOAN)
)
GO

CREATE TABLE HOPDONG
(
	SOHD VARCHAR(5),
	NGAYLAPHD DATE NOT NULL,
	SONGUOIDI INT NOT NULL,
	NOIDUNGHD NVARCHAR(40) NOT NULL,
	NOIDON VARCHAR(5) NOT NULL,
	NGAYDIHD DATE NOT NULL,
	MATOUR VARCHAR(3) NOT NULL,
	MADOAN VARCHAR(5) NOT NULL,

	CONSTRAINT PK_HD_SOHD PRIMARY KEY (SOHD),

	CONSTRAINT FK_HD_MATOUR FOREIGN KEY (MATOUR) REFERENCES TOUR(MATOUR)
	ON UPDATE CASCADE
	ON DELETE CASCADE,

	CONSTRAINT FK_HD_MADOAN FOREIGN KEY (MADOAN) REFERENCES DOAN(MADOAN)
	ON UPDATE CASCADE
	ON DELETE CASCADE
)
GO

CREATE TABLE DIEMDUNGCHAN
(
	MADDC VARCHAR(5),
	TENDDC NVARCHAR(50) NOT NULL,
	THANHPHO NVARCHAR(30) NOT NULL,

	CONSTRAINT PK_DDC_MADDC PRIMARY KEY (MADDC)
)
GO

CREATE TABLE LOTRINH
(
	MANOIDI VARCHAR(5),
	MANOIDEN VARCHAR(5),
	CONSTRAINT PK_LOTRINH PRIMARY KEY (MANOIDI, MANOIDEN)
)
GO

CREATE TABLE LOTRINH_TOUR
(
	MATOUR VARCHAR(3),
	MANOIDI VARCHAR(5),
	MANOIDEN VARCHAR(5),
	SONGAYO INT NOT NULL,
	SONGAYDICUAPT INT NOT NULL, 
	LOAIPHUONGTIEN NVARCHAR (30) NOT NULL,
	LOAIKHACHSAN NVARCHAR (15),

	CONSTRAINT PK_LTTOUR PRIMARY KEY (MATOUR, MANOIDI, MANOIDEN),

	CONSTRAINT FK_LTTOUR_MATOUR FOREIGN KEY (MATOUR) REFERENCES TOUR(MATOUR)
	ON UPDATE CASCADE
	ON DELETE CASCADE,

	CONSTRAINT FK_LTTOUR_LOTRINH FOREIGN KEY (MANOIDI, MANOIDEN) REFERENCES LOTRINH(MANOIDI, MANOIDEN)
	ON UPDATE CASCADE
	ON DELETE CASCADE
)
GO

CREATE TABLE NHANVIENHDDL
(
	MANVHDDL VARCHAR(5),
	TENNV NVARCHAR(30) NOT NULL,
	NGAYSINH DATE NOT NULL,
	PHAINV NVARCHAR(4) NOT NULL,
	DIACHINV NVARCHAR(20) NOT NULL,
	DIENTHOAINV VARCHAR(11),

	CONSTRAINT PK_NVHDDL_MANVHDDL PRIMARY KEY (MANVHDDL) 
)
GO

CREATE TABLE HOPDONG_NV
(
	SOHD VARCHAR(5),
	MANVHDDL VARCHAR(5),
	NOIDUNGHD_NV NVARCHAR(40) NOT NULL,

	CONSTRAINT PK_HOPDONGNV PRIMARY KEY (SOHD, MANVHDDL),

	CONSTRAINT FK_HOPDONGNV_MVNVHDDL FOREIGN KEY (MANVHDDL) REFERENCES NHANVIENHDDL (MANVHDDL)
	ON UPDATE CASCADE
	ON DELETE CASCADE
)
GO

CREATE TABLE CHUYEN
(
	MACHUYEN VARCHAR(5),
	TENCHUYEN NVARCHAR(50) NOT NULL,
	NGAYDICUACHUYEN DATE NOT NULL,
	MANVHDDL VARCHAR(5) NOT NULL,
	MATOUR VARCHAR(3) NOT NULL,

	CONSTRAINT PK_CHUYEN_MACHUYEN PRIMARY KEY (MACHUYEN),

	CONSTRAINT FK_CHUYEN_MANVHDDL FOREIGN KEY (MANVHDDL) REFERENCES NHANVIENHDDL (MANVHDDL)
	ON UPDATE CASCADE
	ON DELETE CASCADE,

	CONSTRAINT FK_CHUYEN_MATOUR FOREIGN KEY (MATOUR) REFERENCES TOUR (MATOUR)
	ON UPDATE CASCADE
	ON DELETE CASCADE
)
GO


--Câu 1: Hiển thị thông tin các hướng dẫn viên du lịch của công ty.
SELECT MANVHDDL[Mã NV], TENNV[Tên NV],  CONVERT(VARCHAR(11),NGAYSINH,103)[Ngày sinh], PHAINV[Giới tính], DIACHINV[Địa chỉ], DIENTHOAINV[SĐT]
FROM NHANVIENHDDL
GO

--Câu 2: Cho biết hiện tại công ty có những tour du lịch nào.
SELECT MATOUR[Mã tour], TENTOUR[Tên tour], SONGAY[Số ngày], SODEM[Số đêm]
FROM TOUR
GO

--Câu 3: Liệt kê các tour có số ngày đi >= 3.
SELECT MATOUR[Mã tour], TENTOUR[Tên tour], SONGAY[Số ngày], SODEM[Số đêm]
FROM TOUR
WHERE SONGAY >=3
GO

--Câu 4: Liệt kê đầy đủ thông tin các điểm tham quan.
SELECT MADTQ[Mã điểm tham quan], TENDTQ[Tên điểm tham quan], NOIDUNG[Nội dung], YNGHIA[Ý nghĩa]
FROM DIEMTQ
GO

--Câu 5: Liệt kê các tour mà có ghé qua điểm du lịch Nha Trang.
SELECT MATOUR[Mã tour], TENTOUR[Tên tour], SONGAY[Số ngày], SODEM[Số đêm]
FROM TOUR
WHERE TENTOUR LIKE N'%Nha Trang%'
GO

--Câu 6: Tìm khách hàng tham dự nhiều chuyến đi nhất của công ty.
SELECT TOP 1 D.HOTEN, D.DIACHI
FROM HOPDONG HD, DOAN D
WHERE D.MADOAN = HD.MADOAN
GROUP BY D.HOTEN, D.DIACHI
ORDER BY COUNT(D.MADOAN) DESC
GO

--Câu 7: Liệt kê mã các đoàn khách và số lượng khách trong đoàn mà đã đăng ký tại đại lý do ‘Nguyễn Văn A’ làm đại diện trong năm 2010.
SET DATEFORMAT DMY
SELECT D.HOTEN, SOHD[Số hợp đồng], NGAYLAPHD[Ngày lập HĐ], NOIDUNGHD[Nội dung HĐ], SONGUOIDI[Số người đi], D.MADOAN[Mã đoàn]
FROM HOPDONG HD, DOAN D
WHERE HD.MADOAN = D.MADOAN AND D.HOTEN LIKE N'Nguyễn Văn A%' AND YEAR(NGAYLAPHD) = '2010' 
GO 

--Câu 8: Cho biết có bao nhiêu chuyến đi đến Nha Trang được mở trong năm 2010.
SELECT COUNT(MACHUYEN) [Số lượng chuyến đi Nha Trang trong năm 2010]
FROM CHUYEN
WHERE TENCHUYEN LIKE N'%Nha Trang%' AND YEAR(NGAYDICUACHUYEN) = '2010'
GO

--Câu 9: Hiển thị thông tin những nhân viên nào đang đi tour (tính đến ngày 10/6/2010).
SELECT CONVERT(VARCHAR(11),C.NGAYDICUACHUYEN,103)[Ngày di chuyển], C.MANVHDDL[Mã NV], NV.TENNV[Họ và tên], CONVERT(VARCHAR(11),NGAYSINH,103)[Ngày sinh], NV.PHAINV[Giới tính], NV.DIACHINV[Địa chỉ], NV.DIENTHOAINV[SĐT]
FROM CHUYEN C, NHANVIENHDDL NV
WHERE C.MANVHDDL = NV.MANVHDDL AND NGAYDICUACHUYEN < '10/6/2010'
GO

--Câu 10: Hiển thị thông tin những những nhân viên nào đang rảnh trong ngày 10/6/2010.
SELECT CONVERT(VARCHAR(11),C.NGAYDICUACHUYEN,103)[Ngày di chuyển], C.MANVHDDL[Mã NV], NV.TENNV[Họ và tên], CONVERT(VARCHAR(11),NGAYSINH,103)[Ngày sinh], NV.PHAINV[Giới tính], NV.DIACHINV[Địa chỉ], NV.DIENTHOAINV[SĐT]
FROM CHUYEN C, NHANVIENHDDL NV
WHERE C.MANVHDDL = NV.MANVHDDL 
EXCEPT
SELECT CONVERT(VARCHAR(11),C.NGAYDICUACHUYEN,103)[Ngày di chuyển], C.MANVHDDL[Mã NV], NV.TENNV[Họ và tên], CONVERT(VARCHAR(11),NGAYSINH,103)[Ngày sinh], NV.PHAINV[Giới tính], NV.DIACHINV[Địa chỉ], NV.DIENTHOAINV[SĐT]
FROM CHUYEN C, NHANVIENHDDL NV
WHERE C.MANVHDDL = NV.MANVHDDL AND NGAYDICUACHUYEN = '10/6/2010'
GO

--Câu 11: Trong năm 2010, nhân viên nào đã lập hợp đồng cho khách du lịch theo đoàn nhiều nhất.
SELECT NV.MANVHDDL, NV.TENNV, COUNT(SOHD) [Số lượng]
FROM HOPDONG_NV HDNV, NHANVIENHDDL NV
WHERE NV.MANVHDDL = HDNV.MANVHDDL
GROUP BY NV.MANVHDDL, NV.TENNV
ORDER BY COUNT(SOHD) DESC