USE [MaintenanceEquipmentManagementSystem];

-- 1. Insert dữ liệu mẫu
-- INSERT INTO tên_bảng (tên cột 1, tên cột 2,...) VALUES
-- (data cột 1, data cột 2,...), 
-- (data cột 1, data cột 2,...), 
-- ...;
			
-- Xóa toàn bộ dữ liệu bảng
-- DELETE FROM tên_bảng

-- Xóa một dòng bất kỳ
-- DELETE FROM DiaChi
-- WHERE AddressID = 3;  (điều kiện để xóa ở đây là có ID là 3)

-- Reset ID về 1
-- DBCC CHECKIDENT ('tên_bảng', RESEED, 0);

-- Sort theo thứ tự bé -> lớn
-- ORDER BY tên_cột ASC

INSERT INTO DiaChi (Province, District, Ward) VALUES 
(N'TP. Hồ Chí Minh', N'Quận Bình Thạnh', N'Phường 7'),
(N'Cần Thơ', N'Quận Ninh Kiều', N'Phường Tân An'),       
(N'Khánh Hòa', N'TP. Nha Trang', N'Phường Lộc Thọ'),       
(N'Hải Phòng', N'Quận Hồng Bàng', N'Phường Phan Bội Châu'),
(N'TP. Hồ Chí Minh', N'Quận 7', N'Tân Phong'),      
(N'TP. Hồ Chí Minh', N'Quận 10', N'Phường 14'),     
(N'TP. Hồ Chí Minh', N'Quận Tân Bình', N'Phường 2'),
(N'TP. Hồ Chí Minh', N'Quận Bình Thạnh', N'Phường 22'),
(N'TP. Hồ Chí Minh', N'Quận 9', N'Long Bình'),
(N'TP. Hồ Chí Minh', N'Quận Tân Phú', N'Sơn Kỳ'),
(N'TP. Hồ Chí Minh', N'Quận Bình Tân', N'An Lạc A'),
(N'TP. Hồ Chí Minh', N'Quận 1', N'Bến Nghé'),
(N'TP. Hồ Chí Minh', N'Quận Thủ Đức', N'Linh Trung'),
(N'Hà Nội', N'Quận Cầu Giấy', N'Dịch Vọng'),
(N'Hà Nội', N'Quận Hoàn Kiếm', N'Tràng Tiền'),
(N'Đà Nẵng', N'Quận Hải Châu', N'Hòa Cường Bắc');

INSERT INTO CongTy (CompanyID, CompanyName, Phone, Email) VALUES
('VLH', N'Công Ty Cổ Phần V Lotus Holdings', '0312225168', 'contact@vlotusholding.com'),
('TVL', N'Công Ty Cổ Phần Toridoll V Lotus', '02873042339', 'info@toridollvlotus.vn'),
('OVL', N'Công Ty Cổ Phần Okano V Lotus', '02838235885', 'info@okanovlotus.vn');

INSERT INTO SuCo (ProblemName, ProblemDescription) VALUES
(N'Không lên nguồn', N'Thiết bị không có tín hiệu điện khi bật nút nguồn'),
(N'Kêu to bất thường', N'Tiếng ồn phát ra từ động cơ hoặc quạt tản nhiệt'),
(N'Rò rỉ nước', N'Nước chảy ra từ thân máy hoặc đường ống'),
(N'Mùi khét', N'Có mùi nhựa cháy hoặc mùi khét điện phát ra từ bên trong'),
(N'Liệt phím điều khiển', N'Các nút bấm hoặc bảng điều khiển cảm ứng không phản hồi'),
(N'Quá nhiệt', N'Thiết bị nóng lên bất thường và tự động ngắt hoạt động');

INSERT INTO NguyenNhanHuHong (RootCauseName) VALUES
(N'Lỗi bo mạch chủ'),
(N'Mòn linh kiện cơ khí'),
(N'Chuột cắn dây điện'),
(N'Sử dụng quá công suất'),
(N'Sụt áp'),
(N'Va đập mạnh trong quá trình sử dụng'),
(N'Côn trùng xâm nhập'),
(N'Sử dụng sai quy trình kỹ thuật'),
(N'Hệ thống thoát nước bị tắc'),
(N'Hỏng cảm biến nhiệt');

INSERT INTO PhuongAn (MethodName) VALUES 
(N'Thay thế linh kiện '),
(N'Sửa chữa'),
(N'Vệ sinh bảo dưỡng định kỳ'),
(N'Thay mới toàn bộ');

INSERT INTO LoaiTaiSan (CategoryID, CategoryName) VALUES 
('FA', N'Tài sản cố định'),
('TO', N'Công cụ dụng cụ'),
('EQ', N'Trang thiết bị'),
('POS', N'Hệ thống bán hàng & CNTT'),
('VEH', N'Phương tiện vận chuyển');

INSERT INTO DonVi (UnitName) VALUES (N'Cái'), (N'Bộ'), (N'Chiếc'), (N'Máy');

INSERT INTO ChuyenMonKyThuat (TechniqueID, TechniqueName) VALUES 
('CMT', N'Cơ / Điện / Nhiệt'), 
('CMIT', N'Hạ tầng mạng'), 
('CMWOOD', N'Mộc & Nội thất');

INSERT INTO LydoTuChoi (RejectReasonName, Category) VALUES 
(N'Vât tư không chính xác', N'Từ chối phê duyệt kế hoạch'), 
(N'Phương án chưa tối ưu', N'Từ chối phê duyệt kế hoạch'),
(N'Sai chuyên môn kỹ thuật', N'Từ chối phân công'),
(N'Trùng lịch bảo trì thiết bị khác', N'Từ chối phân công'),
(N'Khoảng cách di chuyển quá xa', N'Từ chối phân công'),
(N'Thiết bị vẫn còn hư hỏng', N'Từ chối nghiệm thu'),
(N'Linh kiện thay thế không đúng chủng loại', N'Từ chối nghiệm thu');
 
INSERT INTO PhongBanChiNhanh (DepartmentID, DepartmentName, CompanyID, AddressID, DetailAddress) VALUES 
('MTN', N'Phòng Bảo trì', 'VLH', '18', '9-9A Nơ Trang Long'),
('CI-GMTD', N'Coco Ichibanya Giga Mall Thủ Đức', 'OVL', 2, N'242 Đ. Phạm Văn Đồng'),
('CI-LTT', N'Coco Ichibanya Lý Tự Trọng', 'OVL', 1, N'13 Lý Tự Trọng'),
('CS-LTT', N'Conservo Lý Tự Trọng', 'OVL', 1, N'13 Lý Tự Trọng'),
('MU-AEBT', N'Marukame Udon Aeon Mall Bình Tân', 'VLH', 6, N'1 Đường Số 17A'),
('MU-AETP', N'Marukame Udon Aeon Mall Tân Phú', 'VLH', 7, N'30 Tân Thắng'),
('MU-VCQ9', N'Marukame Udon Vincom Grand Park Quận 9', 'VLH', 8, N'88 Phước Thiện'),
('US-VCLM', N'Ussina Sky 77', 'TVL', 9, N'720A Điện Biên Phủ'),
('UM-AETP', N'Ushi Mania Aeon Mall Tân Phú', 'TVL', 7, N'30 Tân Thắng'),
('YS-LTT', N'Yoshinoya Lý Tự Trọng', 'TVL', 1, N'13 Lý Tự Trọng');

INSERT INTO ChucVu (PositionID, PositionName, DepartmentID) VALUES 
('TEC-MTN', N'Kỹ thuật viên bảo trì', 'MTN'),
('MGR-MTN', N'Trưởng phòng bảo trì', 'MTN'),
('MGR-GMTD', N'Cửa hàng trưởng', 'CI-GMTD'),
('MGR-LTT', N'Cửa hàng trưởng', 'CI-LTT'),
('MGR-VCLM', N'Quản lý nhà hàng', 'US-VCLM'),
('SUP-AETP', N'Giám sát ca', 'MU-AETP'),
('SUP-VCQ9', N'Trưởng ca', 'MU-VCQ9'),
('STF-GMTD', N'Bếp trưởng', 'CI-GMTD'),
('STF-AEBT', N'Nhân viên kỹ thuật nội bộ', 'MU-AEBT'),
('STF-AETP', N'Nhân viên vận hành thiết bị', 'UM-AETP');

INSERT INTO LoaiThietBi (TypeID, TypeName, CategoryID) VALUES 
('FA_HVAC', N'Hệ thống điều hòa trung tâm & AHU', 'FA'),
('FA_GEN', N'Máy phát điện & Trạm biến áp', 'FA'),
('FA_SRV', N'Hệ thống Máy chủ & Lưu trữ NAS', 'FA'),
('FA_PROD', N'Dây chuyền đóng gói tự động', 'FA'),
('TO_HAND', N'Dụng cụ kỹ thuật cầm tay', 'TO'),
('TO_FIRE', N'Thiết bị PCCC', 'TO'),
('TO_MEAS', N'Thiết bị đo lường', 'TO'),
('TO_CLEAN', N'Máy vệ sinh công nghiệp', 'TO'),
('EQ_KITCH', N'Thiết bị bếp', 'EQ'),
('EQ_REF', N'Thiết bị lạnh', 'EQ'),
('EQ_PUMP', N'Hệ thống máy bơm & Quạt hút mùi', 'EQ'),
('EQ_LAB', N'Thiết bị kiểm nghiệm thực phẩm', 'EQ'),
('POS_TERM', N'Máy tính tiền & Màn hình cảm ứng', 'POS'),
('POS_PRIN', N'Máy in hóa đơn & Máy in tem', 'POS'),
('POS_NET', N'Thiết bị mạng', 'POS'),
('VEH_TRUCK', N'Xe tải giao hàng lạnh', 'VEH'),
('VEH_LIFT', N'Xe nâng hàng', 'VEH');

INSERT INTO NhaCungCapThietBi (SupplierName, Phone, Email, AddressID, DetailAddress) VALUES 
(N'Tân Long', '0938150833', 'info@tanlong.vn', 1, N'120 Lý Tự Trọng'),
(N'AVC', '0977595733', 'contact@avc-kitchen.com', 9, N'45 Xô Viết Nghệ Tĩnh'),
(N'Quang Sáng', '0909889882', 'kythuat@quangsang.com', 2, N'78 Linh Trung'),
(N'Atech World Việt Nam', '0934020930', 'huy.pham@atechworld.vn', 7, N'15 Lê Trọng Tấn'), 
(N'Toàn Đỉnh', '02839237725', 'sales@toandinh.com', 13, N'452 Thành Thái'),
(N'Hà Yến', '0988661490', 'service@hayen.com.vn', 14, N'22 Cộng Hòa'), 
(N'Vũ Hưng Sinh', '0908809970', 'vuhungsinh@gmail.com', 6, N'102 Kinh Dương Vương'), 
(N'Hoàn Cầu', '0908564058', 'khuong.hoancau@gmail.com', 12, N'Số 5 Nguyễn Văn Linh'), 
(N'Dcorp', '19006140', 'support@dcorp.com.vn', 1, N'Tòa nhà Bitexco, Hải Triều'), 
(N'United Vision', '0971914346', 'linh.uv@unitedvision.com.vn', 1, N'13 Lý Tự Trọng'), 
(N'Sanaky Việt Nam', '02742222098', 'cskh@sanaky.com', 6, N'KCN Tân Tạo'),
(N'Long Thịnh', '0936362499', 'longthinh.tech@gmail.com', 8, N'Lô A4, KCN Cao');

INSERT INTO NhaCungCapVatTu (SupplierName, Phone, Email, DetailAddress) VALUES 
(N'Linh Kiện Điện Tử Viettronic', '02838234567', 'sales@viettronic.vn', N'245 Thành Thái, Phường 14, Quận 10, TP. Hồ Chí Minh'),
(N'Thiết bị điện Schneider VN', '1800585858', 'customercare@se.com', N'Tòa nhà MapleTree, 1060 Nguyễn Văn Linh, Quận 7, TP. Hồ Chí Minh'),
(N'Vật tư Điện lạnh Bách Khoa', '0903123456', 'vattu.bk@gmail.com', N'158 Bạch Đằng, Phường 22, Quận Bình Thạnh, TP. Hồ Chí Minh'),
(N'Thanh Kim Mecha', '0918776655', 'linhkien@thanhkim.vn', N'12 Hoàng Hoa Thám, Phường 12, Quận Tân Bình, TP. Hồ Chí Minh'),
(N'Cơ khí Nhựa Bình Minh', '02838165810', 'info@binhminhplastic.com.vn', N'Lô C1-1, KCN Tân Tạo, Quận Bình Tân, TP. Hồ Chí Minh'),
(N'Vật tư nước Minh Hòa', '02435374262', 'kinhdoanh@minhhoa.com.vn', N'Lô B2-4-4, KCN Nam Thăng Long, Quận Bắc Từ Liêm, Hà Nội'),
(N'Linh kiện bếp Berjaya VN', '0901889900', 'spares@berjaya.vn', N'45 Lê Trọng Tấn, Phường Sơn Kỳ, Quận Tân Phú, TP. Hồ Chí Minh'),
(N'Kitchen Spares Việt Nam', '0933445566', 'support@kitchenspares.vn', N'88 Hàm Nghi, Phường Bến Nghé, Quận 1, TP. Hồ Chí Minh'),
(N'3M Việt Nam - Nhóm Công nghiệp', '02854160429', '3mcare@mmm.com', N'77 Hoàng Văn Thái, Phường Tân Phú, Quận 7, TP. Hồ Chí Minh'),
(N'Cửa hàng Kim khí Tổng hợp Q9', '0905123999', 'kimkhiq9@gmail.com', N'202 Lê Văn Việt, Phường Long Thạnh Mỹ, Quận 9, TP. Hồ Chí Minh');

INSERT INTO Kho (WarehouseID, WarehouseName, DetailAddress) VALUES
('WH-TT', N'Kho Tổng Tân Tạo (Lotus Food)', N'Lô 29-31, Đường Tân Tạo, KCN Tân Tạo, Quận Bình Tân, TP. HCM'),
('WH-TN', N'Kho Trung chuyển Tăng Nhơn Phú', N'16 Tăng Nhơn Phú, P. Phước Long B, TP. Thủ Đức, TP. HCM'),
('WH-NTL', N'Kho VP Nơ Trang Long', N'9-9A Nơ Trang Long, Phường 7, Quận Bình Thạnh, TP. HCM'),
('WH-AK', N'Kho V Lotus An Khánh', N'10 Đường 23, Khu phố 26, P. An Khánh, TP. Thủ Đức, TP. HCM'),
('WH-HN', N'Kho Chi nhánh Hà Nội', N'Dương Nội, Quận Hà Đông, Hà Nội'),
('WH-BD', N'Kho Hub Bình Dương', N'Lô S15, AEON Mall Bình Dương Canary, Thuận An, Bình Dương'),
('WH-PORT', N'Kho Cảng Lotus', N'Cảng Lotus, Quận 7, TP. HCM'),
('WH-BL', N'Kho Đông lạnh Bạc Liêu', N'Khu vực sản xuất thực phẩm đông lạnh, Tỉnh Bạc Liêu');

INSERT INTO LoaiVatTu (MaterialCategoryID, CategoryName, CategoryDescription) VALUES
('MAT_ELEC', N'Vật tư Điện', N'Dây điện, công tắc, ổ cắm, CB, tụ điện, bo mạch điều khiển'),
('MAT_MECH', N'Linh kiện Cơ khí', N'Bạc đạn, dây curoa, bánh răng, ron cao su, lò xo'),
('MAT_REF', N'Vật tư Điện lạnh', N'Gas lạnh, ống đồng, sensor nhiệt, block máy nén, quạt dàn lạnh'),
('MAT_WAT', N'Vật tư Nước', N'Vòi xịt, van khóa, ống nước, bẫy mỡ, phao ngắt nước'),
('MAT_KITCH', N'Linh kiện Bếp đặc thù', N'Thanh nhiệt (điện trở), họng bếp gas, kim đánh lửa, cảm biến lò nướng'),
('MAT_CONS', N'Vật tư Tiêu hao', N'Dầu nhớt, mỡ bôi trơn, băng keo lụa, hóa chất tẩy cặn, que hàn'),
('MAT_IT', N'Linh kiện CNTT & POS', N'Cáp mạng, đầu RJ45, adapter nguồn, giấy in bill, mực máy in tem'),
('MAT_SAFE', N'Vật tư Bảo hộ & PCCC', N'Bình chữa cháy, kim chỉ áp suất, găng cách điện, biển báo an toàn');

INSERT INTO DonViCungCapKyThuatVien (TechnicianSupplierName, Phone, Email, AddressID, DetailAddress) VALUES
(N'Aden Services Việt Nam', '02838276000', 'info@aden_services.vn', 1, N'Tòa nhà Centec, 72 Nguyễn Thị Minh Khai'),
(N'JLL Việt Nam (Facility Management)', '02839119399', 'service.vn@jll.com', 12, N'Số 5 Nguyễn Văn Linh, Quận 7'),
(N'Viettel Construction (VCC)', '1900989868', 'vcc.support@viettel.com.vn', 13, N'285 Cách Mạng Tháng 8, Quận 10'),
(N'Dịch vụ Kỹ thuật Thủ Đô', '02439998888', 'kythuat.thudo@gmail.com', 3, N'Khu đô thị Dịch Vọng, Cầu Giấy'),
(N'Cơ điện Hải Phòng 24/7', '0912345678', 'codienhaiphong@vnn.vn', 17, N'15 Phan Bội Châu, Hồng Bàng'),
(N'Bảo trì Miền Trung (Central Tech)', '02363555666', 'contact@centraltech.vn', 5, N'120 Xô Viết Nghệ Tĩnh, Hải Châu'),
(N'Điện lạnh Nha Trang Xanh', '0905001122', 'nhatrangxanh.tech@gmail.com', 16, N'88 Trần Phú, Lộc Thọ'),
(N'Cơ điện lạnh Cần Thơ (CanTho Mecha)', '02923888999', 'service@ctmecha.vn', 15, N'45 Đại lộ Hòa Bình, Ninh Kiều');

INSERT INTO NhanVien (EmployeeID, FullName, Phone, Email, PositionID) VALUES
('CI-GMTD20036', N'Nguyễn Hoàng Nam', '0901112223', 'nam.nh@vlotus.com', 'MGR-GMTD'),
('MU-AETP66756', N'Lê Thị Thanh Xuân', '0903334445', 'xuan.ltt@vlotus.com', 'SUP-AETP'),
('VLH33412', N'Trần Minh Tâm', '0905556667', 'tam.tm@vlotus.com', 'MGR-MTN'), -- Ông này là Trưởng Bộ phận bảo trì
('VLH33403', N'Hoàng Minh Nghĩa', '0485557374', 'nghia.hm@vlotus.com', 'TEC-MTN'), -- Ông này là KTV nội bộ
('VLH33405', N'Trần Văn Đạt', '0987448596', 'dat.tv@vlotus.com', 'TEC-MTN'), -- Ông này là KTV nội bộ
('UM-AETP66745', N'Phạm Anh Tuấn', '0907778889', 'tuan.pa@vlotus.com', 'STF-AETP'),
('MU-VCQ97789', N'Nguyễn Bảo Ngọc', '0909990001', 'ngoc.nb@vlotus.com', 'SUP-VCQ9');

INSERT INTO KhachHang (FullName, Phone, AddressID, Email, DetailAddress) VALUES
(N'Lê Minh trí', '0888654321', 3, 'tri.lm@outlook.com', N'45 Bạch Đằng'),
(N'Huỳnh Ngọc Anh', '0903445566', 18, NULL, N'9A Nơ Trang Long, Phường 7'),
(N'Trương Minh Đức', '0902778899', 2, 'duc.tm@gmail.com', N'242 Phạm Văn Đồng, Thủ Đức'),
(N'Phan Thanh Sơn', '0912556677', 14, NULL, N'22 Cộng Hòa, P.2'),
(N'Lý Thu Thảo', '0989667788', 7, 'thao.ly@yahoo.com', N'30 Tân Thắng, Sơn Kỳ');

INSERT INTO VatTuLinhKien (MaterialID, MaterialName, MaterialCategoryID, Unit, Price, MaterialSupplierID, MaterialDescription) VALUES
('M001', N'Bo mạch điều khiển điều hòa', 'MAT_ELEC', N'Cái', 1500000, 1, N'Dùng cho máy Daikin/Panasonic'),
('M002', N'Dây Curoa máy rửa bát', 'MAT_MECH', N'Sợi', 250000, 4, N'Chống nhiệt độ cao'),
('M003', N'Đầu đốt bếp Gas công nghiệp', 'MAT_KITCH', N'Bộ', 850000, 7, N'Hợp kim gang chịu nhiệt'), 
('M004', N'Đầu bấm mạng RJ45 Cat6', 'MAT_IT', N'Túi', 120000, 1, N'Túi 100 hạt'), 
('M005', N'Gas lạnh R410A', 'MAT_REF', N'Bình', 2200000, 3, N'Bình 11.3kg dùng cho máy lạnh Inverter'),
('M006', N'Sensor nhiệt độ tủ đông', 'MAT_REF', N'Cái', 180000, 3, N'Cảm biến ngắt nhiệt tự động cho tủ Sanaky'),
('M007', N'Quạt dàn lạnh 220V', 'MAT_REF', N'Cái', 450000, 4, N'Dùng cho tủ mát trưng bày nước ngọt'),
('M008', N'Thanh nhiệt lò nướng (U-Shape)', 'MAT_KITCH', N'Cái', 650000, 7, N'Công suất 2500W, inox 304'),
('M009', N'Súng mồi lửa bếp khè', 'MAT_KITCH', N'Cái', 120000, 8, N'Loại súng dài dùng cho bếp Á công nghiệp'),
('M010', N'Rổ lọc rác máy rửa bát', 'MAT_KITCH', N'Cái', 350000, 8, N'Lưới lọc inox mịn cho máy Winterhalter'),
('M011', N'Vòi xịt sàn áp lực cao', 'MAT_WAT', N'Bộ', 950000, 5, N'Dây dài 15m kèm súng xịt vệ sinh bếp'),
('M012', N'Phao cơ ngắt nước thông minh', 'MAT_WAT', N'Cái', 280000, 6, N'Dùng cho bồn chứa nước dự phòng tầng mái'),
('M013', N'Mỡ bôi trơn thực phẩm', 'MAT_CONS', N'Tuýp', 550000, 9, N'Dùng cho máy xay thịt, máy cắt rau củ (Food Grade)'),
('M014', N'Băng keo lụa (Cao su non)', 'MAT_CONS', N'Cuộn', 15000, 10, N'Dùng quấn nối ống nước/gas'),
('M015', N'Giấy in nhiệt K80', 'MAT_IT', N'Thùng', 650000, 1, N'Thùng 50 cuộn cho máy in hóa đơn'),
('M016', N'Adapter nguồn máy POS', 'MAT_IT', N'Cái', 320000, 1, N'Nguồn 12V-5A thay thế cho máy Dcorp'),
('M017', N'Dung dịch tẩy cặn (Descaler)', 'MAT_CONS', N'Can', 450000.00, 8, N'Chuyên dụng cho máy rửa bát Winterhalter P50'),
('M018', N'Kim phun gas bếp Master INDUC', 'MAT_KITCH', N'Cái', 75000.00, 6, N'Phụ tùng chính hãng cho bếp từ/bếp gas công nghiệp'),
('M019', N'Ổ cứng SSD 240GB Kingston', 'MAT_IT', N'Cái', 550000.00, 1, N'Nâng cấp/thay thế cho máy POS ATECH'),
('M020', N'Ron cao su cửa bàn lạnh', 'MAT_REF', N'Mét', 120000.00, 4, N'Dùng cho bàn lạnh Hoshizaki, chống thất thoát nhiệt');

INSERT INTO ThietBi (ItemID, ItemName, TypeID, Brand, Model, Capacity_Energy, ItemLength, ItemWidth, ItemHeight, 
					UnitID, ItemSupplierID, Condition, UseDate, WarrantyDate, DepreciationPeriod, MaintenanceFrequency, Note) VALUES
('CS302-08', N'Bàn lạnh 3 cánh', 'EQ_REF', N'Hoshizaki', N'RT-186MA-S', N'220V/280W', 1800, 600, 850, 1, 1, N'Đang hoạt động', '2025-03-12', '2025-09-12', N'60 tháng', N'3 tháng', ''),
('ICB-05', N'Lò Vi Sóng Tích Hợp Nướng', 'EQ_KITCH', N'Menumaster', N'XpressChef 2C Jet514', N'220V/2700W', 461, 490, 671, 1, 10, N'Đang hoạt động', '2025-03-12', '2026-03-12', N'48 tháng', N'6 tháng', ''),
('TS0002', N'Bếp từ công nghiệp', 'EQ_KITCH', N'Master INDUC', N'ITOR1-3.5', N'220V/3.5kW', 410, 480, 210, 1, 6, N'Đang hoạt động', '2024-03-12', '2025-03-12', N'36 tháng', N'6 tháng', ''),
('CS302-34', N'Máy rửa chén công nghiệp', 'EQ_KITCH', N'Winter Halter', N'P50', N'380V/11.8kW', 630, 720, 1460, 1, 1, N'Đang hoạt động', '2025-03-12', '2026-03-12', N'84 tháng', N'3 tháng', ''),
('CS302-44', N'Máy lạnh Cassette 42,000 BTU', 'FA_HVAC', N'Daikin', N'FCNQ42MV1', N'3 Pha/42,000 BTU', NULL, NULL, NULL, 1, 7, N'Đang hoạt động', '2025-03-12', '2026-03-12', N'120 tháng', N'4 tháng', ''),
('YTL302-35', N'Vòi phun tráng áp lực', 'EQ_KITCH', N'Equip (T&S)', N'5PR-2S00-H', N'Áp lực cao', NULL, NULL, NULL, 2, 1, N'Đang hoạt động', '2025-03-12', '2026-03-12', N'24 tháng', N'6 tháng', ''),
('CS302-124', N'Máy POS tính tiền', 'POS_TERM', N'ATECH', N'POS-i5-G8', N'Core i5/8GB RAM', NULL, NULL, NULL, 1, 4, N'Đang hoạt động', '2025-03-12', '2026-03-12', N'36 tháng', N'12 tháng/lần', '');

INSERT INTO KyThuatVien (TechnicianID, EmployeeID, TechniqueID, TechnicianSupplierID, TechnicianType) VALUES
('TECH-INT-001', 'VLH33412', 'CMT', NULL, N'Nội bộ'), -- Trưởng bộ phận Bảo trì
('TECH-INT-002', 'VLH33403', 'CMT', NULL, N'Nội bộ'), -- Nhân viên kỹ thuật nội bộ
('TECH-INT-003', 'VLH33405', 'CMWOOD', NULL, N'Nội bộ'), -- Nhân viên kỹ thuật nội bộ
('TECH-EXT-001', NULL, 'CMT', 1, N'Thuê ngoài'), -- Thuê ngoài cơ điện nhiệt
('TECH-EXT-002', NULL, 'CMIT', 3, N'Thuê ngoài'), -- Thuê ngoài mạng
('TECH-EXT-003', NULL, 'CMWOOD', 2, N'Thuê ngoài'),  -- Thuê ngoài nội thật
('TECH-EXT-004', NULL, 'CMT', 4, N'Thuê ngoài');  -- Thuê ngoài ở Hà Nội

INSERT INTO LichLamViecKyThuatVien (TechnicianID, WorkDate, WorkShift, StartTime, EndTime) VALUES
('TECH-INT-001', '2026-03-16', N'Cả ngày', '08:00:00', '17:00:00'),
('TECH-INT-002', '2026-03-16', N'Cả ngày', '08:00:00', '17:00:00'),
('TECH-INT-003', '2026-03-16', N'Cả ngày', '08:00:00', '17:00:00'),
('TECH-INT-001', '2026-03-17', N'Cả ngày', '08:00:00', '17:00:00'),
('TECH-INT-002', '2026-03-17', N'Cả ngày', '08:00:00', '17:00:00'),
('TECH-INT-003', '2026-03-17', N'Cả ngày', '08:00:00', '17:00:00'),
('TECH-INT-001', '2026-03-18', N'Cả ngày', '08:00:00', '17:00:00'),
('TECH-INT-002', '2026-03-18', N'Cả ngày', '08:00:00', '17:00:00'),
('TECH-INT-003', '2026-03-18', N'Cả ngày', '08:00:00', '17:00:00'),
('TECH-INT-001', '2026-03-19', N'Cả ngày', '08:00:00', '17:00:00'),
('TECH-INT-002', '2026-03-19', N'Cả ngày', '08:00:00', '17:00:00'),
('TECH-INT-003', '2026-03-19', N'Cả ngày', '08:00:00', '17:00:00'),
('TECH-INT-001', '2026-03-20', N'Cả ngày', '08:00:00', '17:00:00'),
('TECH-INT-002', '2026-03-20', N'Cả ngày', '08:00:00', '17:00:00'),
('TECH-INT-003', '2026-03-20', N'Cả ngày', '08:00:00', '17:00:00'),
('TECH-INT-001', '2026-03-25', N'Cả ngày', '08:00:00', '17:00:00'),
('TECH-INT-002', '2026-03-25', N'Cả ngày', '08:00:00', '17:00:00'),
('TECH-INT-003', '2026-03-25', N'Cả ngày', '08:00:00', '17:00:00');


INSERT INTO ThongTinTonKhoTaiKho (MaterialID, WarehouseID, QuantityInventory) VALUES
('M001', 'WH-TT', 15), ('M002', 'WH-TT', 30), ('M003', 'WH-TT', 10),
('M005', 'WH-TT', 20), ('M008', 'WH-TT', 12), ('M011', 'WH-TT', 5),
('M013', 'WH-TT', 50), ('M017', 'WH-TT', 40), ('M020', 'WH-TT', 100),
('M004', 'WH-NTL', 200), -- Đầu bấm mạng
('M015', 'WH-NTL', 100), -- Giấy in nhiệt
('M016', 'WH-NTL', 10),  -- Adapter máy POS
('M019', 'WH-NTL', 5),   -- SSD cho máy POS
('M001', 'WH-BD', 5),    -- Bo mạch điều hòa
('M005', 'WH-BD', 10),   -- Gas lạnh
('M011', 'WH-BD', 8),    -- Vòi xịt sàn
('M014', 'WH-BD', 50),   -- Băng keo lụa
('M003', 'WH-AK', 4),    -- Đầu đốt bếp gas
('M009', 'WH-AK', 15),   -- Súng mồi lửa
('M013', 'WH-AK', 10),   -- Mỡ bôi trơn thực phẩm
('M018', 'WH-AK', 20);   -- Kim phun bếp


SELECT * FROM DiaChi