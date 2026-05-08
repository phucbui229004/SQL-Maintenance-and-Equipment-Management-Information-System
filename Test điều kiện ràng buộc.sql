USE [MaintenanceEquipmentManagementSystem];

--1. Ràng buộc FK
--Case 1. FK hợp lệ
INSERT INTO PhieuYeuCauBaoTri 
    (EmployeeID, CustomerID, MaintenanceType, ItemID, ProblemID, PriorityLevel, Image_Video, RequestStatus)
    VALUES 
    ('CI-GMTD20036', NULL, N'Bảo trì khẩn cấp', 'CS302-34', 1, N'Cao', N'test.jpg', N'Chờ phân công');

--Case 2. FK không tồn tại
INSERT INTO PhieuYeuCauBaoTri 
    (EmployeeID, CustomerID, MaintenanceType, ItemID, ProblemID, PriorityLevel, Image_Video, RequestStatus)
    VALUES 
    ('EMP_NOT_EXIST', NULL, N'Bảo trì khẩn cấp', 'CS302-34', 1, N'Cao', N'test.jpg', N'Mới tạo');

-- Case 3. FK không tồn tại
INSERT INTO TienDoBaoTri (PlanID, UpdateByID, ProgressDescription, Image_Video, ProgressStatus)
    VALUES (9999, 'TECH-INT-001', N'Test', N'test.jpg', N'Đang thực hiện');

--Case 4. FK không tồn tại
 INSERT INTO PhanCongKyThuatVien (RequestID, TechnicianID, AssignmentStatus)
    VALUES (1, 'TECH-XXX', N'Đang phân công');

--Case 5. FK không tồn tại
 INSERT INTO KetQuaKhaoSat 
    (SurveyByID, RequestID, MaintenanceType, ProblemID, DamageLevel, RootCauseID, Image_Video, Note, SurveyStatus)
    VALUES 
    ('TECH-INT-001', 1, N'Bảo trì khẩn cấp', 1, N'Nặng', 9999, N'test.jpg', N'Test sai FK', N'Đã khảo sát');


--2. Ràng buộc UNIQUE
--Case 1. Case đúng
INSERT INTO NhanVien (EmployeeID, FullName, Phone, Email, PositionID)
VALUES ('TEST001', N'Nguyễn Test 1', '0999999999', 'test1@gmail.com', 'TEC-MTN');

--Case 2. Trùng phone
INSERT INTO NhanVien (EmployeeID, FullName, Phone, Email, PositionID)
VALUES ('TEST002', N'Nguyễn Test 2', '0999999999', 'test2@gmail.com', 'TEC-MTN');

-- Case 3. Trùng email
INSERT INTO NhanVien (EmployeeID, FullName, Phone, Email, PositionID)
VALUES ('TEST003', N'Nguyễn Test 3', '0988888888', 'test1@gmail.com', 'TEC-MTN');

--Case 4. Case đúng (Khác model thiết bị)
INSERT INTO ThietBi (ItemID, ItemName, TypeID, Brand, Model, UnitID, Condition)
VALUES ('TEST-TB-01', N'Thiết bị test', 'EQ_KITCH', N'TestBrand', 'MODEL-TEST-01', 1, N'Mới');

--Case 5. Trùng model thiết bị
INSERT INTO ThietBi (ItemID, ItemName, TypeID, Brand, Model, UnitID, Condition)
VALUES ('TEST-TB-02', N'Thiết bị test 2', 'EQ_KITCH', N'TestBrand', 'MODEL-TEST-01', 1, N'Mới');


--3. Ràng buộc NOT NULL
--Case 1. Đúng 
INSERT INTO NhanVien (EmployeeID, FullName, Phone, Email, PositionID)
VALUES ('TEST_OK_01', N'Nguyễn Hợp Lệ', '0922222222', 'ok@gmail.com', 'TEC-MTN');

--Case 2. Thiếu tên nhân viên
INSERT INTO NhanVien (EmployeeID, FullName, Phone, Email, PositionID)
VALUES ('TEST_NULL_01', NULL, '0911111111', 'null1@gmail.com', 'TEC-MTN');

--Case 3. Thiếu hình ảnh khi lập phiếu yêu cầu
INSERT INTO PhieuYeuCauBaoTri (EmployeeID, CustomerID, MaintenanceType, ItemID, ProblemID, PriorityLevel, Image_Video, RequestStatus)
VALUES ('CI-GMTD20036', NULL, N'Bảo trì khẩn cấp', 'CS302-34', 1, N'Khẩn cấp', NULL, N'Chờ phân công');

--Case 4. Thiếu hình ảnh khi cập nhật tiến đọo
INSERT INTO TienDoBaoTri (PlanID, UpdateByID, ProgressDescription, Image_Video, ProgressStatus)
VALUES (1, 'TECH-INT-001', N'Test tiến độ', NULL, N'Đang thực hiện');

-- Case 5. Thiếu tên thiết bị
INSERT INTO ThietBi (ItemID, ItemName, TypeID, UnitID, Condition)
VALUES ('TEST_NULL_TB', NULL, 'EQ_KITCH', 1, N'Mới');


--Ràng buộc CHECK
--Case 1. Case đúng (nhân viên gửi)
INSERT INTO PhieuYeuCauBaoTri (EmployeeID, CustomerID, MaintenanceType, ItemID, ProblemID, PriorityLevel, Image_Video, RequestStatus)
VALUES ('CI-GMTD20036', NULL, N'Bảo trì', 'CS302-34', 1, N'Cao', 'img.jpg', N'Chờ phân công');

--Case 2. Case đúng (khách hàng gửi)
INSERT INTO PhieuYeuCauBaoTri (EmployeeID, CustomerID, MaintenanceType, ItemID, ProblemID, PriorityLevel, Image_Video, RequestStatus)
VALUES (NULL, 1, N'Bảo trì', 'CS302-34', 1, N'Cao', 'img.jpg', N'Chờ phân công');

--Case 3. Case sai (cả nhân viên và khách hàng null)
INSERT INTO PhieuYeuCauBaoTri (EmployeeID, CustomerID, MaintenanceType, ItemID, ProblemID, PriorityLevel, Image_Video, RequestStatus)
VALUES (NULL, NULL, N'Bảo trì', 'CS302-34', 1, N'Cao', 'img.jpg', N'Chờ phân công');

--Case 4. Case sai (cả nhân viên và khách hàng đều có giá trị)
INSERT INTO PhieuYeuCauBaoTri (EmployeeID, CustomerID, MaintenanceType, ItemID, ProblemID, PriorityLevel, Image_Video, RequestStatus)
VALUES ('CI-GMTD20036', 1, N'Bảo trì', 'CS302-34', 1, N'Cao', 'img.jpg', N'Chờ phân công');