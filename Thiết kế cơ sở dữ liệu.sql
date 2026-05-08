CREATE DATABASE MaintenanceEquipmentManagementSystem;

USE [MaintenanceEquipmentManagementSystem];

--1. Tạo bảng
CREATE TABLE KhachHang (
	CustomerID INT PRIMARY KEY IDENTITY(1,1), --Khách hàng đăng ký thì hệ thống tự sinh mã
	FullName NVARCHAR (50) NOT NULL,
	Phone VARCHAR(15) NOT NULL ,
	AddressID INT NOT NULL,
	Email NVARCHAR(100),
	DetailAddress NVARCHAR(255)
	);

CREATE TABLE NhanVien (
	EmployeeID VARCHAR(20) PRIMARY KEY, -- Nhân viên có mã nhân sự sẵn -> input vào chứ ko để tự sinh mã
	FullName NVARCHAR (50) NOT NULL,
	Phone VARCHAR(15) UNIQUE NOT NULL ,
	Email NVARCHAR(100) UNIQUE,
	PositionID VARCHAR(20) NOT NULL
	);

CREATE TABLE KyThuatVien (
	TechnicianID VARCHAR(20) PRIMARY KEY,
	EmployeeID VARCHAR(20) NULL, -- null cho phép KTV thuê ngoài tồn tại
	TechniqueID VARCHAR(20) NOT NULL,
	TechnicianSupplierID INT,
	TechnicianType NVARCHAR(20) NOT NULL
	);
CREATE UNIQUE INDEX UIX_KyThuatVien_EmployeeID_Not_Null -- unique để thỏa mqh 1-1, 
ON KyThuatVien(EmployeeID)
WHERE EmployeeID IS NOT NULL;

CREATE TABLE ChuyenMonKyThuat (
	TechniqueID VARCHAR(20) PRIMARY KEY,
	TechniqueName NVARCHAR(100) UNIQUE NOT NULL
	);

CREATE TABLE LichLamViecKyThuatVien (
	ScheduleID INT PRIMARY KEY IDENTITY(1,1),
	TechnicianID VARCHAR(20) NOT NULL,
	WorkDate DATE NOT NULL,
	WorkShift NVARCHAR(50) NOT NULL,
	StartTime TIME NOT NULL,
	EndTime TIME NOT NULL
	);

CREATE TABLE DonViCungCapKyThuatVien (
	TechnicianSupplierID INT PRIMARY KEY IDENTITY(1,1),
	TechnicianSupplierName NVARCHAR(100) UNIQUE NOT NULL,
	Phone VARCHAR(15) NOT NULL,
	Email NVARCHAR(100),
	AddressID INT NOT NULL,
	DetailAddress NVARCHAR(255)
	);
	
CREATE TABLE ChucVu (
	PositionID VARCHAR(20) PRIMARY KEY,
	PositionName NVARCHAR(100) NOT NULL,
	DepartmentID VARCHAR(20) NOT NULL
	);
	
CREATE TABLE PhongBanChiNhanh (
	DepartmentID VARCHAR(20) PRIMARY KEY,
	DepartmentName NVARCHAR(100) NOT NULL,
	CompanyID VARCHAR(20) NOT NULL,
	AddressID INT NOT NULL,
	DetailAddress NVARCHAR(255) NOT NULL
	);

CREATE TABLE CongTy (
	CompanyID VARCHAR(20) PRIMARY KEY,
	CompanyName NVARCHAR(100) UNIQUE NOT NULL,
	Phone VARCHAR(15),
	Email NVARCHAR(100)
	);
	
CREATE TABLE DiaChi (
	AddressID INT PRIMARY KEY IDENTITY(1,1),
	Province NVARCHAR(100) NOT NULL,
	District NVARCHAR(100) NOT NULL,
	Ward NVARCHAR(100) NOT NULL
	);
ALTER TABLE DiaChi
ADD CONSTRAINT UC_Address_Combo UNIQUE (Province, District, Ward);
	
CREATE TABLE PhieuYeuCauBaoTri (
	RequestID INT PRIMARY KEY IDENTITY(1,1),
	EmployeeID VARCHAR(20),
	CustomerID INT,
		CONSTRAINT Rangbuoc1trong2nguoigui 
		CHECK ((EmployeeID IS NOT NULL AND CustomerID IS NULL) OR
		 (EmployeeID IS NULL AND CustomerID IS NOT NULL)),
	MaintenanceType NVARCHAR(100) NOT NULL,
	ItemID VARCHAR(20) NOT NULL,
	ProblemID INT NOT NULL,
	PriorityLevel NVARCHAR(100) NOT NULL,
	Image_Video NVARCHAR(MAX) NOT NULL,
	RequestStatus NVARCHAR(50) NOT NULL,
	RequestedDate DATETIME DEFAULT GETDATE() NOT NULL
	);

	
CREATE TABLE PhanCongKyThuatVien (
	AssignmentID INT PRIMARY KEY IDENTITY(1,1),
	RequestID INT NOT NULL,
	TechnicianID VARCHAR(20) NOT NULL,
	AssignAt DATETIME DEFAULT GETDATE() NOT NULL,
	ConfirmedAt DATETIME NULL,
	RejectReasonID INT NULL,
	RejectNote NVARCHAR(255) NULL,
	RejectedAt DATETIME NULL,
	AssignmentStatus NVARCHAR(50) NOT NULL DEFAULT '...'
	);
	
	
CREATE TABLE KetQuaKhaoSat (
	SurveyID INT PRIMARY KEY IDENTITY(1,1),
	SurveyByID VARCHAR(20) NOT NULL,
	RequestID INT NOT NULL,
	SurveyDate DATETIME DEFAULT GETDATE() NOT NULL,
	MaintenanceType NVARCHAR(100) NOT NULL,
	ProblemID INT NOT NULL,
	DamageLevel NVARCHAR(50) NOT NULL,
	RootCauseID INT NOT NULL,
	Image_Video NVARCHAR(MAX) NOT NULL,
	Note NVARCHAR(255) NOT NULL,
	SurveyStatus NVARCHAR(50) NOT NULL
	);

CREATE TABLE SuCo (
	ProblemID INT PRIMARY KEY IDENTITY(1,1),
	ProblemName NVARCHAR(100) UNIQUE NOT NULL,
	ProblemDescription NVARCHAR(MAX)
	);
	
CREATE TABLE KeHoachBaoTri (
	PlanID INT PRIMARY KEY IDENTITY(1,1),
	CreatedByID VARCHAR(20) NOT NULL,
	SurveyID INT NOT NULL,
	CreateAt DATETIME DEFAULT GETDATE() NOT NULL,
	PlanNote NVARCHAR(255),
	RejectReasonID INT NULL,
	RejectNote NVARCHAR(255) NULL,
	RejectedAt DATETIME NULL,
	PlanStatus NVARCHAR(50) NOT NULL
	);

CREATE TABLE PhuongAn (
	MethodID INT PRIMARY KEY IDENTITY(1,1),
	MethodName NVARCHAR(100) UNIQUE NOT NULL
	);

CREATE TABLE PhuongAnCuaKeHoach (
	PlanMethodID INT PRIMARY KEY IDENTITY(1,1),
	MethodID INT NOT NULL,
	PlanID INT NOT NULL
	);

CREATE TABLE TienDoBaoTri (
	ProgressID INT PRIMARY KEY IDENTITY(1,1),
	PlanID INT NOT NULL,
	UpdateByID VARCHAR(20) NOT NULL,
	UpdateAt DATETIME DEFAULT GETDATE() NOT NULL,
	ProgressDescription NVARCHAR(225),
	Image_Video NVARCHAR(MAX) NOT NULL,
	IsFinal NVARCHAR(20),
	ProgressStatus NVARCHAR(50) NOT NULL
	);
	
CREATE TABLE NghiemThu (
	AcceptanceID INT PRIMARY KEY IDENTITY(1,1),
	ApprovedByID VARCHAR(20) NOT NULL,
	ProgressID INT NOT NULL,
	AcceptedDate DATETIME DEFAULT GETDATE() NOT NULL,
	RejectReasonID INT NULL,
	RejectNote NVARCHAR(255) NULL,
	RejectedAt DATETIME NULL,
	AcceptanceStatus NVARCHAR(50) NOT NULL
	);

CREATE TABLE LyDoTuChoi (
	RejectReasonID INT PRIMARY KEY IDENTITY(1,1),
	RejectReasonName NVARCHAR(100) UNIQUE NOT NULL,
	Category NVARCHAR(100) NOT NULL
	);
	
CREATE TABLE VatTuLinhKien (
	MaterialID VARCHAR(20) PRIMARY KEY,
	MaterialName NVARCHAR(225) NOT NULL,
	MaterialCategoryID VARCHAR(20) NOT NULL,
	Unit NVARCHAR(20),
	Price DECIMAL(18,2),
	MaterialSupplierID INT,
	MaterialDescription NVARCHAR(MAX)
	);

CREATE TABLE LoaiVatTu (
	MaterialCategoryID VARCHAR(20) PRIMARY KEY,
	CategoryName NVARCHAR(225) UNIQUE NOT NULL,
	CategoryDescription NVARCHAR(MAX)
	);

CREATE TABLE VatTuTheoKeHoach (
	PlanMaterialID INT PRIMARY KEY IDENTITY(1,1),
	PlanID INT NOT NULL,
	MaterialID VARCHAR(20) NOT NULL,
	RequiredQuantity INT NOT NULL
	);

CREATE TABLE VatTuThucTeSuDung (
	ActualMaterialID INT PRIMARY KEY IDENTITY(1,1),
	ProgressID INT NOT NULL,
	MaterialID VARCHAR(20) NOT NULL,
	ActualQuantity INT NOT NULL,
	UpdateAt DATETIME DEFAULT GETDATE() NOT NULL,
	Note NVARCHAR(255)
	);

CREATE TABLE NhaCungCapVatTu (
	MaterialSupplierID INT PRIMARY KEY IDENTITY(1,1),
	SupplierName NVARCHAR(225) UNIQUE NOT NULL,
	Phone VARCHAR(15),
	Email NVARCHAR(100),
	DetailAddress NVARCHAR(MAX)
	);

CREATE TABLE Kho (
	WarehouseID VARCHAR(20) PRIMARY KEY,
	WarehouseName NVARCHAR(225) UNIQUE NOT NULL,
	DetailAddress NVARCHAR(MAX) NOT NULL
	);

CREATE TABLE ThongTinTonKhoTaiKho (
	InventoryID INT PRIMARY KEY IDENTITY(1,1),
	MaterialID VARCHAR(20) NOT NULL,
	WarehouseID VARCHAR(20) NOT NULL,
	QuantityInventory INT
	);

CREATE TABLE ThietBi (
	ItemID VARCHAR(20) PRIMARY KEY,
	ItemName NVARCHAR(200) NOT NULL,
	TypeID VARCHAR(20) NOT NULL,
	Brand NVARCHAR(200),
	Model NVARCHAR(200) UNIQUE,
	Capacity_Energy NVARCHAR(200),
	ItemLength DECIMAL(8, 2),
	ItemWidth DECIMAL(8, 2),
	ItemHeight DECIMAL(8, 2),
	UnitID INT NOT NULL,
	ItemSupplierID INT,
	Condition NVARCHAR(50) NOT NULL,
	ImageURL NVARCHAR(MAX),
	UseDate DATE,
	WarrantyDate DATE,
	DepreciationPeriod NVARCHAR(50),
	MaintenanceFrequency NVARCHAR(50),
	Note NVARCHAR(MAX)
	);


CREATE TABLE DieuChuyenThietBi (
	TransferID INT PRIMARY KEY IDENTITY(1,1),
	ItemID VARCHAR(20) NOT NULL,
	TransferDate DATETIME DEFAULT GETDATE() NOT NULL
	);

CREATE TABLE LoaiThietBi (
	TypeID VARCHAR(20) PRIMARY KEY,
	TypeName NVARCHAR(50) NOT NULL,
	CategoryID VARCHAR(20) NOT NULL
	);

CREATE TABLE LoaiTaiSan (
	CategoryID VARCHAR(20) PRIMARY KEY,
	CategoryName NVARCHAR(50) UNIQUE NOT NULL
	);

CREATE TABLE DonVi (
	UnitID INT PRIMARY KEY IDENTITY(1,1),
	UnitName NVARCHAR(50) UNIQUE NOT NULL
	);

CREATE TABLE NhaCungCapThietBi (
	ItemSupplierID INT PRIMARY KEY IDENTITY(1,1),
	SupplierName NVARCHAR(50) UNIQUE,
	Phone VARCHAR(15),
	Email NVARCHAR(100),
	AddressID INT NOT NULL,
	DetailAddress NVARCHAR(MAX) NOT NULL
	);

CREATE TABLE NguyenNhanHuHong (
	RootCauseID INT PRIMARY KEY IDENTITY(1,1),
	RootCauseName NVARCHAR(225) UNIQUE NOT NULL
	);

--2. Thiết lập mối quan hệ
-- thằng nào giữ ID của thằng khác là bảng con (đầu N là bản con)
--ALTER TABLE [Tên_Bảng_Con]
--ADD CONSTRAINT FK_[Tên_Bảng_Con]_[Tên_Bảng_Cha]
--FOREIGN KEY ([Tên_Khóa_Ngoại]) 
--REFERENCES [Tên_Bảng_Cha]([Tên_Khóa_Chính]);

-- Xóa FK
--ALTER TABLE [Tên_Bảng_Con]
--DROP CONSTRAINT FK_[Tên_Khóa_Ngoại_Đã_Đặt];

--1. 
ALTER TABLE PhieuYeuCauBaoTri 
ADD CONSTRAINT FK_PhieuYeuCauBaoTri_NhanVien
FOREIGN KEY (EmployeeID) REFERENCES NhanVien(EmployeeID);

--2.
ALTER TABLE PhieuYeuCauBaoTri 
ADD CONSTRAINT FK_PhieuYeuCauBaoTri_KhachHang
FOREIGN KEY (CustomerID) REFERENCES KhachHang(CustomerID);

--3.
ALTER TABLE PhieuYeuCauBaoTri
ADD CONSTRAINT FK_PhieuYeuCauBaoTri_ThietBi
FOREIGN KEY (ItemID) REFERENCES ThietBi(ItemID);

--4.
ALTER TABLE PhanCongKyThuatVien
ADD CONSTRAINT FK_PhanCongKyThuatVien_PhieuYeuCauBaoTri
FOREIGN KEY (RequestID) REFERENCES PhieuYeuCauBaoTri(RequestID);

--5.
ALTER TABLE KetQuaKhaoSat
ADD CONSTRAINT FK_KetQuaKhaoSat_PhieuYeuCauBaoTri
FOREIGN KEY (RequestID) REFERENCES PhieuYeuCauBaoTri(RequestID);

--6.
ALTER TABLE PhieuYeuCauBaoTri
ADD CONSTRAINT FK_PhieuYeuCauBaoTri_SuCo
FOREIGN KEY (ProblemID) REFERENCES SuCo(ProblemID);

--7.
ALTER TABLE PhanCongKyThuatVien
ADD CONSTRAINT FK_PhanCongKyThuatVien_KyThuatVien
FOREIGN KEY (TechnicianID) REFERENCES KyThuatVien(TechnicianID);

--8.
ALTER TABLE  KeHoachBaoTri
ADD CONSTRAINT FK_KeHoachBaoTri_KetQuaKhaoSat
FOREIGN KEY (SurveyID) REFERENCES KetQuaKhaoSat(SurveyID);

--9.
ALTER TABLE KetQuaKhaoSat
ADD CONSTRAINT FK_KetQuaKhaoSat_SuCo
FOREIGN KEY (ProblemID) REFERENCES SuCo(ProblemID);

--10.
ALTER TABLE KetQuaKhaoSat
ADD CONSTRAINT FK_KetQuaKhaoSat_NguyenNhanHuHong
FOREIGN KEY (RootCauseID) REFERENCES NguyenNhanHuHong(RootCauseID);

--11.
ALTER TABLE KetQuaKhaoSat
ADD CONSTRAINT FK_KetQuaKhaoSat_KyThuatVien
FOREIGN KEY (SurveyByID) REFERENCES KyThuatVien(TechnicianID);

--12.
ALTER TABLE TienDoBaoTri
ADD CONSTRAINT FK_TienDoBaoTri_KeHoachBaoTri
FOREIGN KEY (PlanID) REFERENCES KeHoachBaoTri(PlanID);

--13.
ALTER TABLE KeHoachBaoTri
ADD CONSTRAINT FK_KeHoachBaoTri_KyThuatVien
FOREIGN KEY (CreatedByID) REFERENCES KyThuatVien(TechnicianID);

--14.
ALTER TABLE  VatTuTheoKeHoach
ADD CONSTRAINT FK_VatTuTheoKeHoach_KeHoachBaoTri
FOREIGN KEY (PlanID) REFERENCES KeHoachBaoTri(PlanID);

--15.
ALTER TABLE  PhuongAnCuaKeHoach
ADD CONSTRAINT FK_PhuongAnCuaKeHoach_KeHoachBaoTri
FOREIGN KEY (PlanID) REFERENCES KeHoachBaoTri(PlanID)

--16.
ALTER TABLE PhuongAnCuaKeHoach
ADD CONSTRAINT FK_PhuongAnCuaKeHoach_PhuongAn
FOREIGN KEY (MethodID) REFERENCES PhuongAn(MethodID);

--17.
ALTER TABLE NghiemThu
ADD CONSTRAINT FK_NghiemThu_KyThuatVien
FOREIGN KEY (ApprovedByID) REFERENCES KyThuatVien(TechnicianID);

--18.
ALTER TABLE NghiemThu
ADD CONSTRAINT FK_NghiemThu_TienDoBaoTri
FOREIGN KEY (ProgressID) REFERENCES TienDoBaoTri(ProgressID);
ALTER TABLE NghiemThu
ADD CONSTRAINT UC_NghiemThu_Progress UNIQUE (ProgressID);

--19.
ALTER TABLE TienDoBaoTri
ADD CONSTRAINT FK_TienDoBaoTri_KyThuatVien
FOREIGN KEY (UpdateByID) REFERENCES KyThuatVien(TechnicianID);

--20.
ALTER TABLE VatTuThucTeSuDung
ADD CONSTRAINT FK_VatTuThucTeSuDung_TienDoBaoTri
FOREIGN KEY (ProgressID) REFERENCES TienDoBaoTri(ProgressID);

--21.
ALTER TABLE VatTuThucTeSuDung
ADD CONSTRAINT FK_VatTuThucTeSuDung_VatTuLinhKien
FOREIGN KEY (MaterialID) REFERENCES VatTuLinhKien(MaterialID);

--22.
ALTER TABLE VatTuTheoKeHoach
ADD CONSTRAINT FK_VatTuTheoKeHoach_VatTuLinhKien
FOREIGN KEY (MaterialID) REFERENCES VatTuLinhKien(MaterialID);

--23.
ALTER TABLE VatTuLinhKien
ADD CONSTRAINT FK_VatTuLinhKien_LoaiVatTu
FOREIGN KEY (MaterialCategoryID) REFERENCES LoaiVatTu(MaterialCategoryID);

--24.
ALTER TABLE VatTuLinhKien
ADD CONSTRAINT FK_VatTuLinhKien_NhaCungCapVatTu
FOREIGN KEY (MaterialSupplierID) REFERENCES NhaCungCapVatTu(MaterialSupplierID);

--25.
ALTER TABLE ThongTinTonKhoTaiKho
ADD CONSTRAINT FK_ThongTinTonKhoTaiKho_VatTuLinhKien
FOREIGN KEY (MaterialID) REFERENCES VatTuLinhKien(MaterialID);

--26.
ALTER TABLE ThongTinTonKhoTaiKho
ADD CONSTRAINT FK_ThongTinTonKhoTaiKho_Kho
FOREIGN KEY (WarehouseID) REFERENCES Kho(WarehouseID);

--27. 
ALTER TABLE KyThuatVien
ADD CONSTRAINT FK_KyThuatVien_NhanVien
FOREIGN KEY (EmployeeID) REFERENCES NhanVien(EmployeeID);

--28.
ALTER TABLE LichLamViecKyThuatVien
ADD CONSTRAINT FK_LichLamViecKyThuatVien_KyThuatVien
FOREIGN KEY (TechnicianID) REFERENCES KyThuatVien(TechnicianID);

--29.
ALTER TABLE KyThuatVien
ADD CONSTRAINT FK_KyThuatVien_ChuyenMonKyThuat
FOREIGN KEY (TechniqueID) REFERENCES ChuyenMonKyThuat(TechniqueID);

--30.
ALTER TABLE KyThuatVien
ADD CONSTRAINT FK_KyThuatVien_DonViCungCapKyThuatVien
FOREIGN KEY (TechnicianSupplierID) REFERENCES DonViCungCapKyThuatVien(TechnicianSupplierID);

--31.
ALTER TABLE DonViCungCapKyThuatVien
ADD CONSTRAINT FK_DonViCungCapKyThuatVien_DiaChi
FOREIGN KEY (AddressID) REFERENCES DiaChi(AddressID);

--32.
ALTER TABLE NhanVien
ADD CONSTRAINT FK_NhanVien_ChucVu
FOREIGN KEY (PositionID) REFERENCES ChucVu(PositionID);

--33.
ALTER TABLE ChucVu
ADD CONSTRAINT FK_ChucVu_PhongBanChiNhanh
FOREIGN KEY (DepartmentID) REFERENCES PhongBanChiNhanh(DepartmentID);

--34.
ALTER TABLE PhongBanChiNhanh
ADD CONSTRAINT FK_PhongBanChiNhanh_CongTy
FOREIGN KEY (CompanyID) REFERENCES CongTy(CompanyID);

--35.
ALTER TABLE PhongBanChiNhanh
ADD CONSTRAINT FK_PhongBanChiNhanh_DiaChi
FOREIGN KEY (AddressID) REFERENCES DiaChi(AddressID);

--36.
ALTER TABLE KhachHang
ADD CONSTRAINT FK_KhachHang_DiaChi
FOREIGN KEY (AddressID) REFERENCES DiaChi(AddressID);

--37.
ALTER TABLE DieuChuyenThietBi
ADD CONSTRAINT FK_DieuChuyenThietBi_ThietBi
FOREIGN KEY (ItemID) REFERENCES ThietBi(ItemID);

--38.
ALTER TABLE ThietBi
ADD CONSTRAINT FK_ThietBi_LoaiThietBi
FOREIGN KEY (TypeID) REFERENCES LoaiThietBi(TypeID);

--39.
ALTER TABLE LoaiThietBi
ADD CONSTRAINT FK_LoaiThietBi_LoaiTaiSan
FOREIGN KEY (CategoryID) REFERENCES LoaiTaiSan(CategoryID);

--40.
ALTER TABLE ThietBi
ADD CONSTRAINT FK_ThietBi_DonVi
FOREIGN KEY (UnitID) REFERENCES DonVi(UnitID);

--41.
ALTER TABLE ThietBi
ADD CONSTRAINT FK_ThietBi_NhaCungCapThietBi
FOREIGN KEY (ItemSupplierID) REFERENCES NhaCungCapThietBi(ItemSupplierID);

--42.
ALTER TABLE NhaCungCapThietBi
ADD CONSTRAINT FK_NhaCungCapThietBi_DiaChi
FOREIGN KEY (AddressID) REFERENCES DiaChi(AddressID);

--43.
ALTER TABLE PhanCongKyThuatVien
ADD CONSTRAINT FK_PhanCongKyThuatVien_LyDoTuChoi
FOREIGN KEY (RejectReasonID) REFERENCES LyDoTuChoi(RejectReasonID);

--44.
ALTER TABLE KeHoachBaoTri
ADD CONSTRAINT FK_KeHoachBaoTri_LyDoTuChoi
FOREIGN KEY (RejectReasonID) REFERENCES LyDoTuChoi(RejectReasonID);

--45.
ALTER TABLE NghiemThu
ADD CONSTRAINT FK_NghiemThu_LyDoTuChoi
FOREIGN KEY (RejectReasonID) REFERENCES LyDoTuChoi(RejectReasonID);

--3. Thiết lập điều kiện chống trùng dữ liệu theo cặp
ALTER TABLE ThongTinTonKhoTaiKho
ADD CONSTRAINT UQ_ThongTinTonKhoTaiKho_Material_Warehouse
UNIQUE (MaterialID, WarehouseID);

ALTER TABLE LichLamViecKyThuatVien
ADD CONSTRAINT UQ_LichLamViecKyThuatVien_Technician_Date_Shift
UNIQUE (TechnicianID, WorkDate, WorkShift);
