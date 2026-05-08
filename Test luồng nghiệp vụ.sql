USE [MaintenanceEquipmentManagementSystem];

--(Xóa toàn bộ thông tin các bảng nghiệp vụ - reset ID từ đầu:
DELETE FROM NghiemThu;
DELETE FROM VatTuThucTeSuDung;
DELETE FROM TienDoBaoTri;
DELETE FROM PhuongAnCuaKeHoach;
DELETE FROM VatTuTheoKeHoach;
DELETE FROM KeHoachBaoTri;
DELETE FROM KetQuaKhaoSat;
DELETE FROM PhanCongKyThuatVien;
DELETE FROM PhieuYeuCauBaoTri;

DBCC CHECKIDENT ('NghiemThu', RESEED, 0);
DBCC CHECKIDENT ('VatTuThucTeSuDung', RESEED, 0);
DBCC CHECKIDENT ('TienDoBaoTri', RESEED, 0);
DBCC CHECKIDENT ('PhuongAnCuaKeHoach', RESEED, 0);
DBCC CHECKIDENT ('VatTuTheoKeHoach', RESEED, 0);
DBCC CHECKIDENT ('KeHoachBaoTri', RESEED, 0);
DBCC CHECKIDENT ('KetQuaKhaoSat', RESEED, 0);
DBCC CHECKIDENT ('PhanCongKyThuatVien', RESEED, 0);
DBCC CHECKIDENT ('PhieuYeuCauBaoTri', RESEED, 0);
--)

--(--Xem thông tin các bảng nghiệp vụ:
SELECT * FROM PhieuYeuCauBaoTri;
SELECT * FROM PhanCongKyThuatVien;
SELECT * FROM KetQuaKhaoSat;
SELECT * FROM KeHoachBaoTri;
SELECT * FROM VatTuTheoKeHoach;
SELECT * FROM PhuongAnCuaKeHoach;
SELECT * FROM TienDoBaoTri;
SELECT * FROM VatTuThucTeSuDung;
SELECT * FROM NghiemThu;
--)





---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
--1. Xử lý yêu cầu bảo trì theo quy trình chuẩn
BEGIN TRY
    BEGIN TRAN;
    DECLARE 
        @RequestID INT,
        @SurveyID INT,
        @PlanID INT,
        @ProgressID_Working INT,
        @ProgressID_Final INT;
    DECLARE 
        @ProblemID INT = (SELECT TOP 1 ProblemID FROM SuCo WHERE ProblemName = N'Không lên nguồn'),
        @RootCauseID INT = (SELECT TOP 1 RootCauseID FROM NguyenNhanHuHong WHERE RootCauseName = N'Lỗi bo mạch chủ'),
        @MethodID    INT = (SELECT TOP 1 MethodID FROM PhuongAn WHERE MethodName = N'Sửa chữa');
    DECLARE 
        @EmployeeID   VARCHAR(20) = 'CI-GMTD20036',
        @TechnicianID VARCHAR(20) = 'TECH-INT-001',
        @ItemID       VARCHAR(20) = 'CS302-34';

    IF @ProblemID IS NULL OR @RootCauseID IS NULL OR @MethodID IS NULL
    BEGIN
        THROW 50001, N'Không tìm thấy dữ liệu danh mục cần thiết.', 1;
    END

    /*1) Nhân viên tạo phiếu yêu cầu bảo trì*/
    INSERT INTO PhieuYeuCauBaoTri (EmployeeID, CustomerID, MaintenanceType, ItemID, ProblemID, PriorityLevel, Image_Video, RequestStatus)
    VALUES (@EmployeeID, NULL, N'Bảo trì khẩn cấp', @ItemID, @ProblemID, N'Khẩn cấp', N'request_001.jpg', N'Chờ phân công');

    SET @RequestID = SCOPE_IDENTITY();

    /*2) Trưởng bộ phận phân công kỹ thuật viên
          Trạng thái: Đang phân công*/
    INSERT INTO PhanCongKyThuatVien (RequestID, TechnicianID, AssignAt, ConfirmedAt, RejectReasonID, RejectNote, RejectedAt, AssignmentStatus)
    VALUES (@RequestID, @TechnicianID, GETDATE(), NULL, NULL, NULL, NULL, N'Đang phân công');

    UPDATE PhieuYeuCauBaoTri
    SET RequestStatus = N'Đang phân công'
    WHERE RequestID = @RequestID;

    /*3) Kỹ thuật viên đồng ý phân công
          Trạng thái: Đã phân công*/
    UPDATE PhanCongKyThuatVien
    SET ConfirmedAt = GETDATE(),
        AssignmentStatus = N'Đã phân công'
    WHERE RequestID = @RequestID
      AND TechnicianID = @TechnicianID
      AND AssignmentStatus = N'Đang phân công';

    UPDATE PhieuYeuCauBaoTri
    SET RequestStatus = N'Đã phân công'
    WHERE RequestID = @RequestID;

    /*4) Kỹ thuật viên đi khảo sát
          Trạng thái: Đã khảo sát*/
    INSERT INTO KetQuaKhaoSat (SurveyByID, RequestID, SurveyDate, MaintenanceType, ProblemID, DamageLevel, RootCauseID, Image_Video, Note, SurveyStatus)
    VALUES (@TechnicianID, @RequestID, GETDATE(), N'Bảo trì khẩn cấp', @ProblemID, N'Nặng', @RootCauseID, N'survey_001.jpg', N'Đã kiểm tra, xác định hỏng bo mạch điều khiển', N'Đã khảo sát');

    SET @SurveyID = SCOPE_IDENTITY();

    UPDATE PhieuYeuCauBaoTri
    SET RequestStatus = N'Đã khảo sát'
    WHERE RequestID = @RequestID;

    /*5) Kỹ thuật viên tạo kế hoạch bảo trì
          Trạng thái: Đã lập kế hoạch*/
    INSERT INTO KeHoachBaoTri (CreatedByID, SurveyID, CreateAt, PlanNote, RejectReasonID, RejectNote, RejectedAt, PlanStatus)
    VALUES (@TechnicianID, @SurveyID, GETDATE(), N'Thay bo mạch điều khiển, kiểm tra vận hành lại, vệ sinh và test tải', NULL, NULL, NULL, N'Đã lập kế hoạch');

    SET @PlanID = SCOPE_IDENTITY();

    UPDATE PhieuYeuCauBaoTri
    SET RequestStatus = N'Đã lập kế hoạch'
    WHERE RequestID = @RequestID;

    /*6) Tạo phương án của kế hoạch*/
    INSERT INTO PhuongAnCuaKeHoach (MethodID, PlanID)
    VALUES (@MethodID, @PlanID);

    /*7) Cập nhật vật tư cần sử dụng theo kế hoạch*/
    INSERT INTO VatTuTheoKeHoach (PlanID, MaterialID, RequiredQuantity)
    VALUES (@PlanID, 'M001', 1),
           (@PlanID, 'M013', 1),
           (@PlanID, 'M017', 1);

    /*8) Trưởng bộ phận duyệt kế hoạch + kiểm tra vật tư
          Nếu đủ vật tư: Đang thực hiện
          Nếu thiếu vật tư: Chờ vật tư*/
    DECLARE @HasEnoughMaterial BIT = 1;

    IF EXISTS (
        SELECT 1
        FROM VatTuTheoKeHoach v
        LEFT JOIN (
            SELECT MaterialID, SUM(ISNULL(QuantityInventory, 0)) AS TotalQty
            FROM ThongTinTonKhoTaiKho
            GROUP BY MaterialID
        ) t ON t.MaterialID = v.MaterialID
        WHERE v.PlanID = @PlanID AND ISNULL(t.TotalQty, 0) < v.RequiredQuantity
       )
    BEGIN
        SET @HasEnoughMaterial = 0;
    END

    IF @HasEnoughMaterial = 1
    BEGIN UPDATE PhieuYeuCauBaoTri
          SET RequestStatus = N'Đang thực hiện'
          WHERE RequestID = @RequestID;
    END
    ELSE
    BEGIN UPDATE PhieuYeuCauBaoTri
          SET RequestStatus = N'Chờ vật tư'
          WHERE RequestID = @RequestID;
    END

    /*9) Kỹ thuật viên cập nhật tiến độ trong quá trình thực hiện
          - Dòng 1: đang làm
          - Dòng 2: hoàn thành và chờ nghiệm thu*/
    INSERT INTO TienDoBaoTri (PlanID, UpdateByID, UpdateAt, ProgressDescription, Image_Video, IsFinal, ProgressStatus)
    VALUES (@PlanID, @TechnicianID, GETDATE(), N'Đã tháo lắp, thay thế bo mạch, vệ sinh và chạy thử thiết bị', N'progress_working_001.jpg', N'Không', N'Đang thực hiện');

    SET @ProgressID_Working = SCOPE_IDENTITY();

    INSERT INTO TienDoBaoTri (PlanID, UpdateByID, UpdateAt, ProgressDescription, Image_Video, IsFinal, ProgressStatus)
    VALUES ( @PlanID, @TechnicianID, GETDATE(), N'Đã hoàn tất công việc, chuyển sang bước nghiệm thu', N'progress_final_001.jpg', N'Có', N'Chờ nghiệm thu');

    SET @ProgressID_Final = SCOPE_IDENTITY();

    UPDATE PhieuYeuCauBaoTri
    SET RequestStatus = N'Chờ nghiệm thu'
    WHERE RequestID = @RequestID;

    /*10) Cập nhật vật tư thực tế sử dụng
          - mỗi lần ghi nhận là 1 dòng lịch sử*/
    INSERT INTO VatTuThucTeSuDung (ProgressID, MaterialID, ActualQuantity, UpdateAt, Note)
    VALUES (@ProgressID_Final, 'M001', 1, GETDATE(), N'Đã dùng 1 bo mạch thay thế'),
           (@ProgressID_Final, 'M013', 1, GETDATE(), N'Đã dùng mỡ bôi trơn khi lắp lại'),
           (@ProgressID_Final, 'M017', 1, GETDATE(), N'Đã dùng dung dịch tẩy cặn trước khi hoàn tất');

    /*11) Nghiệm thu
          Trạng thái: Đã nghiệm thu*/
    INSERT INTO NghiemThu (ApprovedByID, ProgressID, AcceptedDate, RejectReasonID, RejectNote, RejectedAt, AcceptanceStatus)
    VALUES (@TechnicianID, @ProgressID_Final, GETDATE(), NULL, NULL, NULL, N'Đã nghiệm thu');

    UPDATE PhieuYeuCauBaoTri
    SET RequestStatus = N'Đã nghiệm thu'
    WHERE RequestID = @RequestID;

    /*12) Đóng phiếu
          Trạng thái cuối: Hoàn thành*/
    UPDATE PhieuYeuCauBaoTri
    SET RequestStatus = N'Hoàn thành'
    WHERE RequestID = @RequestID;

    COMMIT TRAN;

    /*Kết quả kiểm tra toàn luồng*/
    SELECT
    yc.RequestID,
    yc.RequestStatus,
    yc.RequestedDate,
    yc.MaintenanceType,
    yc.PriorityLevel,
    tb.ItemName,
    tb.Model,
    sc.ProblemName,
    nn.RootCauseName,
    ktv.TechnicianID,
    nv.FullName AS TechnicianName,
    cty.CompanyName,
    pb.DepartmentName,
    dc.Province,
    dc.District,
    dc.Ward,
    pb.DetailAddress,
    pc.AssignmentStatus,
    ks.SurveyStatus,
    kh.PlanStatus,
    pa.MethodName,
    td_work.ProgressID AS WorkingProgressID,
    td_work.ProgressStatus AS WorkingStatus,

    td_final.ProgressID AS FinalProgressID,
    td_final.ProgressStatus AS FinalStatus,

    nt.AcceptanceStatus

FROM PhieuYeuCauBaoTri yc
	LEFT JOIN ThietBi tb ON tb.ItemID = yc.ItemID
	LEFT JOIN SuCo sc ON sc.ProblemID = yc.ProblemID
	LEFT JOIN KetQuaKhaoSat ks ON ks.RequestID = yc.RequestID
	LEFT JOIN NguyenNhanHuHong nn ON nn.RootCauseID = ks.RootCauseID
	OUTER APPLY (
	    SELECT TOP 1 *
	    FROM PhanCongKyThuatVien
	    WHERE RequestID = yc.RequestID
	    ORDER BY AssignmentID DESC
		) pc
	LEFT JOIN KyThuatVien ktv ON ktv.TechnicianID = pc.TechnicianID
	LEFT JOIN NhanVien nv ON nv.EmployeeID = ktv.EmployeeID
	LEFT JOIN NhanVien nv_req ON nv_req.EmployeeID = yc.EmployeeID
	LEFT JOIN ChucVu cv ON cv.PositionID = nv_req.PositionID
	LEFT JOIN PhongBanChiNhanh pb ON pb.DepartmentID = cv.DepartmentID
	LEFT JOIN CongTy cty ON cty.CompanyID = pb.CompanyID
	LEFT JOIN DiaChi dc ON dc.AddressID = pb.AddressID
	LEFT JOIN KeHoachBaoTri kh ON kh.SurveyID = ks.SurveyID
	LEFT JOIN PhuongAnCuaKeHoach pak ON pak.PlanID = kh.PlanID
	LEFT JOIN PhuongAn pa ON pa.MethodID = pak.MethodID
	LEFT JOIN TienDoBaoTri td_work ON td_work.PlanID = kh.PlanID 
	AND td_work.ProgressStatus = N'Đang thực hiện'
	LEFT JOIN TienDoBaoTri td_final ON td_final.PlanID = kh.PlanID 
	AND td_final.ProgressStatus = N'Chờ nghiệm thu'
	LEFT JOIN NghiemThu nt ON nt.ProgressID = td_final.ProgressID

WHERE yc.RequestID = @RequestID;

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN;

    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH;


---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
--2. Xử lý quy trình bảo trì trong trường hợp kỹ thuật viên từ chối phân công
BEGIN TRY
    BEGIN TRAN;
    DECLARE 
        @RequestID INT,
        @SurveyID INT,
        @PlanID INT,
        @ProgressID_Working INT,
        @ProgressID_Final INT;
    DECLARE 
        @ProblemID INT = (SELECT TOP 1 ProblemID FROM SuCo WHERE ProblemName = N'Rò rỉ nước'),
        @RootCauseID INT = (SELECT TOP 1 RootCauseID FROM NguyenNhanHuHong WHERE RootCauseName = N'Hệ thống thoát nước bị tắc'),
        @MethodID INT = (SELECT TOP 1 MethodID FROM PhuongAn WHERE MethodName = N'Vệ sinh bảo dưỡng định kỳ'),
        @RejectReasonID INT = (SELECT TOP 1 RejectReasonID 
                               FROM LyDoTuChoi 
                               WHERE RejectReasonName = N'Trùng lịch bảo trì thiết bị khác');
    DECLARE 
        @CustomerID INT = (SELECT TOP 1 CustomerID FROM KhachHang WHERE FullName = N'Phan Thanh Sơn'),
        @TechnicianRejectID VARCHAR(20) = 'TECH-INT-002',
        @TechnicianAcceptID VARCHAR(20) = 'TECH-INT-001',
        @ItemID VARCHAR(20) = 'CS302-08';

    IF @ProblemID IS NULL OR @RootCauseID IS NULL OR @MethodID IS NULL OR @RejectReasonID IS NULL OR @CustomerID IS NULL
    BEGIN
        THROW 50001, N'Không tìm thấy dữ liệu danh mục cần thiết.', 1;
    END

    /*1) Khách hàng tạo phiếu yêu cầu bảo trì*/
    INSERT INTO PhieuYeuCauBaoTri (EmployeeID, CustomerID, MaintenanceType, ItemID, ProblemID, PriorityLevel, Image_Video, RequestStatus)
    VALUES (NULL, @CustomerID, N'Bảo trì định kỳ', @ItemID, @ProblemID, N'Khẩn cấp', N'request_002.jpg', N'Chờ phân công');

    SET @RequestID = SCOPE_IDENTITY();

    /*2) Trưởng bộ phận phân công kỹ thuật viên lần 1
       Trạng thái: Đang phân công*/
    INSERT INTO PhanCongKyThuatVien(RequestID, TechnicianID, AssignAt, ConfirmedAt, RejectReasonID, RejectNote, RejectedAt, AssignmentStatus)
    VALUES (@RequestID, @TechnicianRejectID, GETDATE(), NULL, NULL, NULL, NULL, N'Đang phân công');

    UPDATE PhieuYeuCauBaoTri
    SET RequestStatus = N'Đang phân công'
    WHERE RequestID = @RequestID;

    /*3) Kỹ thuật viên lần 1 từ chối phân công
       Trạng thái: Từ chối phân công*/
    UPDATE PhanCongKyThuatVien
    SET RejectReasonID = @RejectReasonID,
        RejectNote = N'Đang có lịch bảo trì thiết bị khác trùng thời gian nên không thể nhận việc.',
        RejectedAt = GETDATE(),
        AssignmentStatus = N'Từ chối phân công'
    WHERE RequestID = @RequestID
      AND TechnicianID = @TechnicianRejectID
      AND AssignmentStatus = N'Đang phân công';

    UPDATE PhieuYeuCauBaoTri
    SET RequestStatus = N'Từ chối phân công'
    WHERE RequestID = @RequestID;

    /*4) Trưởng bộ phận phân công lại cho kỹ thuật viên khác
       Trạng thái: Đang phân công*/
    INSERT INTO PhanCongKyThuatVien (RequestID, TechnicianID, AssignAt, ConfirmedAt, RejectReasonID, RejectNote, RejectedAt, AssignmentStatus)
    VALUES (@RequestID, @TechnicianAcceptID, GETDATE(), NULL, NULL, NULL, NULL, N'Đang phân công');

    UPDATE PhieuYeuCauBaoTri
    SET RequestStatus = N'Đang phân công'
    WHERE RequestID = @RequestID;

    /*5) Kỹ thuật viên lần 2 đồng ý phân công
       Trạng thái: Đã phân công*/
    UPDATE PhanCongKyThuatVien
    SET ConfirmedAt = GETDATE(),
        AssignmentStatus = N'Đã phân công'
    WHERE RequestID = @RequestID
      AND TechnicianID = @TechnicianAcceptID
      AND AssignmentStatus = N'Đang phân công';

    UPDATE PhieuYeuCauBaoTri
    SET RequestStatus = N'Đã phân công'
    WHERE RequestID = @RequestID;

    /*6) Kỹ thuật viên đi khảo sát
       Trạng thái: Đã khảo sát*/
    INSERT INTO KetQuaKhaoSat (SurveyByID, RequestID, SurveyDate, MaintenanceType, ProblemID, DamageLevel, RootCauseID, Image_Video, Note, SurveyStatus)
    VALUES (@TechnicianAcceptID, @RequestID, GETDATE(), N'Bảo trì định kỳ', @ProblemID, N'Trung bình', @RootCauseID, N'survey_002.jpg', N'Kiểm tra xác định hệ thống thoát nước bị tắc, gây rò rỉ nước', N'Đã khảo sát');

    SET @SurveyID = SCOPE_IDENTITY();

    UPDATE PhieuYeuCauBaoTri
    SET RequestStatus = N'Đã khảo sát'
    WHERE RequestID = @RequestID;

    /*7) Kỹ thuật viên tạo kế hoạch bảo trì
       Trạng thái: Đã lập kế hoạch*/
    INSERT INTO KeHoachBaoTri (CreatedByID, SurveyID, CreateAt, PlanNote, RejectReasonID, RejectNote, RejectedAt, PlanStatus)
    VALUES (@TechnicianAcceptID, @SurveyID, GETDATE(), N'Vệ sinh hệ thống thoát nước, kiểm tra gioăng, thay ron nếu cần và chạy thử lại thiết bị', NULL, NULL, NULL, N'Đã lập kế hoạch');

    SET @PlanID = SCOPE_IDENTITY();

    UPDATE PhieuYeuCauBaoTri
    SET RequestStatus = N'Đã lập kế hoạch'
    WHERE RequestID = @RequestID;

    /*8) Tạo phương án của kế hoạch*/
    INSERT INTO PhuongAnCuaKeHoach (MethodID, PlanID)
    VALUES (@MethodID, @PlanID);

    /*9) Cập nhật vật tư cần sử dụng theo kế hoạch*/
    INSERT INTO VatTuTheoKeHoach (PlanID, MaterialID, RequiredQuantity)
    VALUES (@PlanID, 'M017', 1),  -- Dung dịch tẩy cặn
           (@PlanID, 'M020', 1),  -- Ron cao su cửa bàn lạnh
           (@PlanID, 'M011', 1);  -- Vòi xịt sàn áp lực cao

    /*10) Trưởng bộ phận duyệt kế hoạch + kiểm tra vật tư
       Nếu đủ vật tư: Đang thực hiện
       Nếu thiếu vật tư: Chờ vật tư*/
    DECLARE @HasEnoughMaterial BIT = 1;

    IF EXISTS (
			   SELECT 1
			   FROM VatTuTheoKeHoach v
			   LEFT JOIN(
						 SELECT MaterialID, SUM(ISNULL(QuantityInventory, 0)) AS TotalQty
						 FROM ThongTinTonKhoTaiKho
						 GROUP BY MaterialID
						 ) t ON t.MaterialID = v.MaterialID
			   WHERE v.PlanID = @PlanID AND ISNULL(t.TotalQty, 0) < v.RequiredQuantity
			   )
    BEGIN
        SET @HasEnoughMaterial = 0;
    END

    IF @HasEnoughMaterial = 1
    BEGIN
        UPDATE PhieuYeuCauBaoTri
        SET RequestStatus = N'Đang thực hiện'
        WHERE RequestID = @RequestID;
    END
    ELSE
    BEGIN
        UPDATE PhieuYeuCauBaoTri
        SET RequestStatus = N'Chờ vật tư'
        WHERE RequestID = @RequestID;
    END

    /*11) Kỹ thuật viên cập nhật tiến độ trong quá trình thực hiện
       - Dòng 1: đang làm
       - Dòng 2: hoàn thành và chờ nghiệm thu*/
    INSERT INTO TienDoBaoTri (PlanID, UpdateByID, UpdateAt, ProgressDescription, Image_Video, IsFinal, ProgressStatus)
    VALUES (@PlanID, @TechnicianAcceptID, GETDATE(), N'Đã vệ sinh hệ thống thoát nước, kiểm tra ron và chạy thử thiết bị', N'progress_working_002.jpg', N'Không', N'Đang thực hiện');

    SET @ProgressID_Working = SCOPE_IDENTITY();

    INSERT INTO TienDoBaoTri (PlanID, UpdateByID, UpdateAt, ProgressDescription, Image_Video, IsFinal, ProgressStatus)
    VALUES (@PlanID, @TechnicianAcceptID, GETDATE(), N'Đã hoàn tất công việc, chuyển sang bước nghiệm thu', N'progress_final_002.jpg', N'Có', N'Chờ nghiệm thu');

    SET @ProgressID_Final = SCOPE_IDENTITY();

    UPDATE PhieuYeuCauBaoTri
    SET RequestStatus = N'Chờ nghiệm thu'
    WHERE RequestID = @RequestID;

    /*12) Cập nhật vật tư thực tế sử dụng*/
    INSERT INTO VatTuThucTeSuDung (ProgressID, MaterialID, ActualQuantity, UpdateAt, Note)
    VALUES (@ProgressID_Final, 'M017', 1, GETDATE(), N'Đã dùng dung dịch tẩy cặn khi vệ sinh'),
		   (@ProgressID_Final, 'M020', 1, GETDATE(), N'Đã thay ron cao su bị hỏng'),
		   (@ProgressID_Final, 'M011', 1, GETDATE(), N'Đã dùng vòi xịt sàn để vệ sinh khu vực làm việc');

    /*13) Nghiệm thu
       Trạng thái: Đã nghiệm thu*/
    INSERT INTO NghiemThu (ApprovedByID, ProgressID, AcceptedDate, RejectReasonID, RejectNote, RejectedAt, AcceptanceStatus)
    VALUES (@TechnicianAcceptID, @ProgressID_Final, GETDATE(), NULL, NULL, NULL, N'Đã nghiệm thu');

    UPDATE PhieuYeuCauBaoTri
    SET RequestStatus = N'Đã nghiệm thu'
    WHERE RequestID = @RequestID;

    /*14) Đóng phiếu
       Trạng thái cuối: Hoàn thành*/
    UPDATE PhieuYeuCauBaoTri
    SET RequestStatus = N'Hoàn thành'
    WHERE RequestID = @RequestID;

    COMMIT TRAN;

    /*A. Thông tin tổng hợp của phiếu yêu cầu và các bảng nghiệp vụ phía sau*/
    SELECT
        yc.RequestID,
        yc.RequestStatus,
        yc.RequestedDate,
        yc.MaintenanceType,
        yc.PriorityLevel,
        yc.ItemID,
        tb.ItemName,
        pc.CurrentAssignmentID,
        pc.CurrentTechnicianID,
        ktv.TechnicianType,
        pc.CurrentAssignmentStatus,
        ks.SurveyID,
        ks.SurveyStatus,
        kh.PlanID,
        kh.PlanStatus,
        pak.PlanMethodID,
        pa.MethodName,
        td1.ProgressID AS WorkingProgressID,
        td1.ProgressStatus AS WorkingProgressStatus,
        td2.ProgressID AS FinalProgressID,
        td2.ProgressStatus AS FinalProgressStatus,
        nt.AcceptanceID,
        nt.AcceptanceStatus
    FROM PhieuYeuCauBaoTri yc
    LEFT JOIN ThietBi tb ON tb.ItemID = yc.ItemID
    OUTER APPLY
    (
        SELECT TOP 1
            pc1.AssignmentID AS CurrentAssignmentID,
            pc1.TechnicianID AS CurrentTechnicianID,
            pc1.AssignmentStatus AS CurrentAssignmentStatus
        FROM PhanCongKyThuatVien pc1
        WHERE pc1.RequestID = yc.RequestID
        ORDER BY pc1.AssignmentID DESC
    ) pc
    LEFT JOIN KyThuatVien ktv ON ktv.TechnicianID = pc.CurrentTechnicianID
    LEFT JOIN KetQuaKhaoSat ks ON ks.RequestID = yc.RequestID
    LEFT JOIN KeHoachBaoTri kh ON kh.SurveyID = ks.SurveyID
    LEFT JOIN PhuongAnCuaKeHoach pak ON pak.PlanID = kh.PlanID
    LEFT JOIN PhuongAn pa ON pa.MethodID = pak.MethodID
    LEFT JOIN TienDoBaoTri td1 ON td1.PlanID = kh.PlanID AND td1.ProgressStatus = N'Đang thực hiện'
    LEFT JOIN TienDoBaoTri td2 ON td2.PlanID = kh.PlanID AND td2.ProgressStatus = N'Chờ nghiệm thu'
    LEFT JOIN NghiemThu nt ON nt.ProgressID = td2.ProgressID
    WHERE yc.RequestID = @RequestID;

    /*B. Lịch sử phân công, bao gồm cả lần bị từ chối và lần phân công lại*/
    SELECT
        pc.AssignmentID,
        pc.RequestID,
        pc.TechnicianID,
        ktv.TechnicianType,
        pc.AssignAt,
        pc.ConfirmedAt,
        pc.RejectedAt,
        pc.AssignmentStatus,
        pc.RejectReasonID,
        rr.RejectReasonName,
        pc.RejectNote
    FROM PhanCongKyThuatVien pc
    LEFT JOIN LyDoTuChoi rr ON rr.RejectReasonID = pc.RejectReasonID
    LEFT JOIN KyThuatVien ktv ON ktv.TechnicianID = pc.TechnicianID
    WHERE pc.RequestID = @RequestID
    ORDER BY pc.AssignmentID;

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN;

    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH;


---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
--3. Xử lý quy trình bảo trì trong trường hợp Trưởng bộ phận từ chối phê duyệt kế hoạch bảo trì
BEGIN TRY
    BEGIN TRAN;

    DECLARE 
        @RequestID INT,
        @SurveyID INT,
        @PlanID_Reject INT,
        @PlanID_Approve INT,
        @ProgressID_Working INT,
        @ProgressID_Final INT;

    DECLARE 
        @ProblemID INT = (SELECT TOP 1 ProblemID FROM SuCo WHERE ProblemName = N'Kêu to bất thường'),
        @RootCauseID INT = (SELECT TOP 1 RootCauseID FROM NguyenNhanHuHong WHERE RootCauseName = N'Mòn linh kiện cơ khí'),
        @MethodID INT = (SELECT TOP 1 MethodID FROM PhuongAn WHERE MethodName = N'Sửa chữa'),
        @RejectReasonID INT = (SELECT TOP 1 RejectReasonID
                               FROM LyDoTuChoi
                               WHERE RejectReasonName = N'Phương án chưa tối ưu');

    DECLARE 
        @CustomerID INT = (SELECT TOP 1 CustomerID FROM KhachHang WHERE FullName = N'Phan Thanh Sơn'),
        @TechnicianID VARCHAR(20) = 'TECH-INT-003',
        @ItemID VARCHAR(20) = 'CS302-34';

    IF @ProblemID IS NULL OR @RootCauseID IS NULL OR @MethodID IS NULL OR @RejectReasonID IS NULL OR @CustomerID IS NULL
    BEGIN
        THROW 50001, N'Không tìm thấy dữ liệu danh mục cần thiết.', 1;
    END

    /*1) Khách hàng tạo phiếu yêu cầu bảo trì*/
    INSERT INTO PhieuYeuCauBaoTri (EmployeeID, CustomerID, MaintenanceType, ItemID, ProblemID, PriorityLevel, Image_Video, RequestStatus)
    VALUES (NULL, @CustomerID, N'Bảo trì định kỳ', @ItemID, @ProblemID, N'Cao', N'request_plan_reject.jpg', N'Chờ phân công');
    SET @RequestID = SCOPE_IDENTITY();

    /*2) Trưởng bộ phận phân công kỹ thuật viên*/
    INSERT INTO PhanCongKyThuatVien (RequestID, TechnicianID, AssignAt, ConfirmedAt, RejectReasonID, RejectNote, RejectedAt, AssignmentStatus)
    VALUES (@RequestID, @TechnicianID,GETDATE(),GETDATE(),NULL,NULL,NULL,N'Đã phân công');

    UPDATE PhieuYeuCauBaoTri
    SET RequestStatus = N'Đã phân công'
    WHERE RequestID = @RequestID;

    /*3) Kỹ thuật viên đi khảo sát*/
    INSERT INTO KetQuaKhaoSat (SurveyByID, RequestID, SurveyDate, MaintenanceType,ProblemID, DamageLevel, RootCauseID, Image_Video, Note, SurveyStatus)
    VALUES(@TechnicianID,@RequestID,GETDATE(),N'Bảo trì định kỳ',@ProblemID,N'Trung bình',@RootCauseID,N'survey_plan_reject.jpg',N'Kiểm tra xác định nguyên nhân mòn linh kiện cơ khí gây tiếng ồn',N'Đã khảo sát');
    SET @SurveyID = SCOPE_IDENTITY();

    UPDATE PhieuYeuCauBaoTri
    SET RequestStatus = N'Đã khảo sát'
    WHERE RequestID = @RequestID;

    /*4) Kế hoạch lần 1 - BỊ TỪ CHỐ */
    INSERT INTO KeHoachBaoTri(CreatedByID, SurveyID, CreateAt, PlanNote,RejectReasonID, RejectNote, RejectedAt, PlanStatus)
    VALUES(@TechnicianID,@SurveyID,GETDATE(),N'Chỉ vệ sinh thiết bị, chưa xử lý triệt để nguyên nhân mòn linh kiện cơ khí',@RejectReasonID,N'Phương án chưa tối ưu, chưa giải quyết đúng nguyên nhân gây tiếng ồn',GETDATE(),N'Từ chối duyệt kế hoạch');
    SET @PlanID_Reject = SCOPE_IDENTITY();

    UPDATE PhieuYeuCauBaoTri
    SET RequestStatus = N'Từ chối duyệt kế hoạch'
    WHERE RequestID = @RequestID;

    /*5) Kế hoạch lần 2 - ĐƯỢC DUYỆT*/
    INSERT INTO KeHoachBaoTri(CreatedByID, SurveyID, CreateAt, PlanNote,RejectReasonID, RejectNote, RejectedAt, PlanStatus)
    VALUES(@TechnicianID,@SurveyID,GETDATE(),N'Thay dây curoa, kiểm tra bạc đạn, tra mỡ bôi trơn và chạy thử thiết bị',NULL,NULL,NULL,N'Đã lập kế hoạch');
    SET @PlanID_Approve = SCOPE_IDENTITY();

    UPDATE PhieuYeuCauBaoTri
    SET RequestStatus = N'Đã lập kế hoạch'
    WHERE RequestID = @RequestID;

    /*6) Tạo phương án của kế hoạch*/
    INSERT INTO PhuongAnCuaKeHoach(MethodID, PlanID)
    VALUES(@MethodID,@PlanID_Approve);

    /*7) Cập nhật vật tư cần sử dụng theo kế hoạch*/
    INSERT INTO VatTuTheoKeHoach(PlanID, MaterialID, RequiredQuantity)
    VALUES
        (@PlanID_Approve, 'M002', 1),
        (@PlanID_Approve, 'M013', 1),
        (@PlanID_Approve, 'M017', 1);

    /*8) Kiểm tra vật tư trong kho*/
    DECLARE @HasEnoughMaterial BIT = 1;
    IF EXISTS (
        SELECT 1
        FROM VatTuTheoKeHoach v
        LEFT JOIN (
            SELECT MaterialID, SUM(ISNULL(QuantityInventory, 0)) AS TotalQty
            FROM ThongTinTonKhoTaiKho
            GROUP BY MaterialID) t ON t.MaterialID = v.MaterialID
        WHERE v.PlanID = @PlanID_Approve
          AND ISNULL(t.TotalQty, 0) < v.RequiredQuantity)
    BEGIN
        SET @HasEnoughMaterial = 0;
    END

    IF @HasEnoughMaterial = 1
    BEGIN
        UPDATE PhieuYeuCauBaoTri
        SET RequestStatus = N'Đang thực hiện'
        WHERE RequestID = @RequestID;
    END
    ELSE
    BEGIN
        UPDATE PhieuYeuCauBaoTri
        SET RequestStatus = N'Chờ vật tư'
        WHERE RequestID = @RequestID;
    END

    /*9) Kỹ thuật viên cập nhật tiến độ trong quá trình thực hiện*/
    INSERT INTO TienDoBaoTri(PlanID, UpdateByID, UpdateAt,ProgressDescription, Image_Video, IsFinal, ProgressStatus)
    VALUES(@PlanID_Approve,@TechnicianID,GETDATE(),N'Đã tháo lắp, thay dây curoa, tra mỡ bôi trơn và kiểm tra bạc đạn',N'progress_working_plan_reject.jpg',N'Không',N'Đang thực hiện');
    SET @ProgressID_Working = SCOPE_IDENTITY();

    INSERT INTO TienDoBaoTri(PlanID, UpdateByID, UpdateAt,ProgressDescription, Image_Video, IsFinal, ProgressStatus)
    VALUES(@PlanID_Approve,@TechnicianID,GETDATE(),N'Đã hoàn tất công việc, chuyển sang bước nghiệm thu',N'progress_final_plan_reject.jpg',N'Có',N'Chờ nghiệm thu');
    SET @ProgressID_Final = SCOPE_IDENTITY();

    UPDATE PhieuYeuCauBaoTri
    SET RequestStatus = N'Chờ nghiệm thu'
    WHERE RequestID = @RequestID;

    /*10) Cập nhật vật tư thực tế sử dụng*/
    INSERT INTO VatTuThucTeSuDung(ProgressID, MaterialID, ActualQuantity, UpdateAt, Note)
    VALUES
        (@ProgressID_Final, 'M002', 1, GETDATE(), N'Đã dùng 1 dây curoa thay thế'),
        (@ProgressID_Final, 'M013', 1, GETDATE(), N'Đã dùng mỡ bôi trơn khi lắp lại'),
        (@ProgressID_Final, 'M017', 1, GETDATE(), N'Đã dùng dung dịch tẩy cặn trước khi hoàn tất');

    /* 11) Nghiệm thu*/
    INSERT INTO NghiemThu(ApprovedByID, ProgressID, AcceptedDate,RejectReasonID, RejectNote, RejectedAt, AcceptanceStatus)
    VALUES(@TechnicianID,@ProgressID_Final,GETDATE(),NULL,NULL,NULL,N'Đã nghiệm thu');

    UPDATE PhieuYeuCauBaoTri
    SET RequestStatus = N'Đã nghiệm thu'
    WHERE RequestID = @RequestID;

    /*12) Đóng phiếu*/
    UPDATE PhieuYeuCauBaoTri
    SET RequestStatus = N'Hoàn thành'
    WHERE RequestID = @RequestID;

    COMMIT TRAN;

   /*A. Thông tin tổng hợp của phiếu yêu cầu và các bảng nghiệp vụ phía sau*/
	SELECT
		yc.RequestID,
		yc.RequestStatus,
		yc.RequestedDate,
		yc.MaintenanceType,
		yc.PriorityLevel,
		tb.ItemName,
		pc.CurrentAssignmentStatus,
		ks.SurveyID,
		ks.SurveyStatus,
		planLatest.PlanID,
		planLatest.PlanStatus,
		pa.MethodName,
		td1.ProgressID AS WorkingProgressID,
		td1.ProgressStatus AS WorkingProgressStatus,
		td2.ProgressID AS FinalProgressID,
		td2.ProgressStatus AS FinalProgressStatus,
		nt.AcceptanceID,
		nt.AcceptanceStatus
	FROM PhieuYeuCauBaoTri yc
		LEFT JOIN ThietBi tb ON tb.ItemID = yc.ItemID
	OUTER APPLY
	(
		SELECT TOP 1
        pc1.AssignmentStatus AS CurrentAssignmentStatus
		FROM PhanCongKyThuatVien pc1
		WHERE pc1.RequestID = yc.RequestID
		ORDER BY pc1.AssignmentID DESC
	) pc
	LEFT JOIN KetQuaKhaoSat ks ON ks.RequestID = yc.RequestID
	OUTER APPLY
		(
    SELECT TOP 1
        kh1.PlanID,
        kh1.PlanStatus
    FROM KeHoachBaoTri kh1
    WHERE kh1.SurveyID = ks.SurveyID
    ORDER BY kh1.PlanID DESC
	) planLatest
	LEFT JOIN PhuongAnCuaKeHoach pak ON pak.PlanID = planLatest.PlanID
	LEFT JOIN PhuongAn pa ON pa.MethodID = pak.MethodID
	LEFT JOIN TienDoBaoTri td1 ON td1.PlanID = planLatest.PlanID AND td1.ProgressStatus = N'Đang thực hiện'
	LEFT JOIN TienDoBaoTri td2 ON td2.PlanID = planLatest.PlanID AND td2.ProgressStatus = N'Chờ nghiệm thu'
	LEFT JOIN NghiemThu nt ON nt.ProgressID = td2.ProgressID
	WHERE yc.RequestID = @RequestID;


/* =========================================================
   B. Lịch sử kế hoạch
   - có người khảo sát
   - có người lập kế hoạch
   - có phương án
   - có vật tư, tên vật tư, số lượng
   - có lý do từ chối, thời gian, trạng thái
   ========================================================= */
	SELECT
		kh.PlanID,
		ksSurvey.SurveyID,
		COALESCE(nvSurvey.FullName, ktvSurvey.TechnicianID) AS SurveyTechnicianName,
		COALESCE(nvCreate.FullName, ktvCreate.TechnicianID) AS PlanCreatorName,
		kh.CreateAt,
		kh.PlanNote,
		pa.MethodName,
		vtp.MaterialID,
		vt.MaterialName,
		vtp.RequiredQuantity,
		kh.RejectReasonID,
		rr.RejectReasonName,
		kh.RejectNote,
		kh.RejectedAt,
		kh.PlanStatus
	FROM KeHoachBaoTri kh
	LEFT JOIN KetQuaKhaoSat ksSurvey ON ksSurvey.SurveyID = kh.SurveyID
	LEFT JOIN KyThuatVien ktvSurvey ON ktvSurvey.TechnicianID = ksSurvey.SurveyByID
	LEFT JOIN NhanVien nvSurvey ON nvSurvey.EmployeeID = ktvSurvey.EmployeeID
	LEFT JOIN KyThuatVien ktvCreate ON ktvCreate.TechnicianID = kh.CreatedByID
	LEFT JOIN NhanVien nvCreate ON nvCreate.EmployeeID = ktvCreate.EmployeeID
	LEFT JOIN PhuongAnCuaKeHoach pak ON pak.PlanID = kh.PlanID
	LEFT JOIN PhuongAn pa ON pa.MethodID = pak.MethodID
	LEFT JOIN VatTuTheoKeHoach vtp ON vtp.PlanID = kh.PlanID
	LEFT JOIN VatTuLinhKien vt ON vt.MaterialID = vtp.MaterialID
	LEFT JOIN LyDoTuChoi rr ON rr.RejectReasonID = kh.RejectReasonID
	WHERE kh.SurveyID = @SurveyID
	ORDER BY kh.PlanID, vt.MaterialID;

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN;

    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH;


---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
--4. Xử lý quy trình bảo trì trong trường hợp nghiệm thu không đạt
USE [MaintenanceEquipmentManagementSystem];
SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRAN;
    DECLARE 
        @RequestID INT,
        @SurveyID INT,
        @PlanID INT,
        @ProgressID_Working_1 INT,
        @ProgressID_Final_1 INT,
        @ProgressID_Working_2 INT,
        @ProgressID_Final_2 INT;

    DECLARE 
        @ProblemID INT = (SELECT TOP 1 ProblemID FROM SuCo WHERE ProblemName = N'Không lên nguồn'),
        @RootCauseID INT = (SELECT TOP 1 RootCauseID FROM NguyenNhanHuHong WHERE RootCauseName = N'Lỗi bo mạch chủ'),
        @MethodID INT = (SELECT TOP 1 MethodID FROM PhuongAn WHERE MethodName = N'Sửa chữa'),
        @RejectReasonID INT = (SELECT TOP 1 RejectReasonID
                               FROM LyDoTuChoi
                               WHERE RejectReasonName = N'Thiết bị vẫn còn hư hỏng');

    DECLARE 
        @CustomerID INT = (SELECT TOP 1 CustomerID FROM KhachHang WHERE FullName = N'Lý Thu Thảo'),
        @TechnicianID VARCHAR(20) = 'TECH-INT-003',
        @ApproverID VARCHAR(20) = 'TECH-INT-001',
        @ItemID VARCHAR(20) = 'CS302-124';

    IF @ProblemID IS NULL OR @RootCauseID IS NULL OR @MethodID IS NULL OR @RejectReasonID IS NULL OR @CustomerID IS NULL
    BEGIN
        THROW 50001, N'Không tìm thấy dữ liệu danh mục cần thiết.', 1;
    END

    /*1) Khách hàng tạo phiếu yêu cầu bảo trì*/
    INSERT INTO PhieuYeuCauBaoTri(EmployeeID, CustomerID, MaintenanceType, ItemID, ProblemID,PriorityLevel, Image_Video, RequestStatus)
    VALUES(NULL,@CustomerID,N'Bảo trì định kỳ',@ItemID,@ProblemID,N'Cao',N'request_accept_reject.jpg',N'Chờ phân công');
    SET @RequestID = SCOPE_IDENTITY();

    /*2) Trưởng bộ phận phân công kỹ thuật viên*/
    INSERT INTO PhanCongKyThuatVien(RequestID, TechnicianID, AssignAt, ConfirmedAt,RejectReasonID, RejectNote, RejectedAt,AssignmentStatus)
    VALUES(@RequestID,@TechnicianID,GETDATE(),GETDATE(),NULL,NULL,NULL,N'Đã phân công');
    UPDATE PhieuYeuCauBaoTri
    SET RequestStatus = N'Đã phân công'
    WHERE RequestID = @RequestID;

    /*3) Kỹ thuật viên đi khảo sát*/
    INSERT INTO KetQuaKhaoSat(SurveyByID, RequestID, SurveyDate, MaintenanceType,ProblemID, DamageLevel, RootCauseID, Image_Video, Note, SurveyStatus)
    VALUES(@TechnicianID,@RequestID,GETDATE(),N'Bảo trì định kỳ',@ProblemID,N'Trung bình',@RootCauseID,N'survey_accept_reject.jpg',N'Kiểm tra xác định nguồn cấp có vấn đề, cần thay adapter nguồn và kiểm tra lại hệ thống',N'Đã khảo sát');
    SET @SurveyID = SCOPE_IDENTITY();

    UPDATE PhieuYeuCauBaoTri
    SET RequestStatus = N'Đã khảo sát'
    WHERE RequestID = @RequestID;

    /*4) Kỹ thuật viên tạo kế hoạch bảo trì*/
    INSERT INTO KeHoachBaoTri(CreatedByID, SurveyID, CreateAt, PlanNote,RejectReasonID, RejectNote, RejectedAt, PlanStatus)
    VALUES(@TechnicianID,@SurveyID,GETDATE(),N'Thay adapter nguồn, kiểm tra SSD, test lại máy POS và theo dõi nguồn cấp',NULL,NULL,NULL,N'Đã lập kế hoạch');
    SET @PlanID = SCOPE_IDENTITY();

    UPDATE PhieuYeuCauBaoTri
    SET RequestStatus = N'Đã lập kế hoạch'
    WHERE RequestID = @RequestID;

    /*5) Tạo phương án của kế hoạch*/
    INSERT INTO PhuongAnCuaKeHoach(MethodID, PlanID)
    VALUES(@MethodID,@PlanID);

    /*6) Cập nhật vật tư cần sử dụng theo kế hoạch*/
    INSERT INTO VatTuTheoKeHoach(PlanID, MaterialID, RequiredQuantity)
    VALUES
        (@PlanID, 'M016', 1),
        (@PlanID, 'M019', 1);

    /*7) Kiểm tra vật tư trong kho*/
    DECLARE @HasEnoughMaterial BIT = 1;
    IF EXISTS (
        SELECT 1
        FROM VatTuTheoKeHoach v
        LEFT JOIN (
            SELECT MaterialID, SUM(ISNULL(QuantityInventory, 0)) AS TotalQty
            FROM ThongTinTonKhoTaiKho
            GROUP BY MaterialID) t ON t.MaterialID = v.MaterialID
        WHERE v.PlanID = @PlanID
          AND ISNULL(t.TotalQty, 0) < v.RequiredQuantity)
    BEGIN
        SET @HasEnoughMaterial = 0;
    END

    IF @HasEnoughMaterial = 1
    BEGIN
        UPDATE PhieuYeuCauBaoTri
        SET RequestStatus = N'Đang thực hiện'
        WHERE RequestID = @RequestID;
    END
    ELSE
    BEGIN
        UPDATE PhieuYeuCauBaoTri
        SET RequestStatus = N'Chờ vật tư'
        WHERE RequestID = @RequestID;
    END

    /*8) Kỹ thuật viên cập nhật tiến độ lần 1*/
    INSERT INTO TienDoBaoTri(PlanID, UpdateByID, UpdateAt,ProgressDescription, Image_Video, IsFinal, ProgressStatus)
    VALUES(@PlanID,@TechnicianID,GETDATE(),N'Đã thay adapter nguồn, kiểm tra lại đường cấp điện và test máy POS',N'progress_accept_reject_working_1.jpg',N'Không',N'Đang thực hiện');
    SET @ProgressID_Working_1 = SCOPE_IDENTITY();

    INSERT INTO TienDoBaoTri(PlanID, UpdateByID, UpdateAt,ProgressDescription, Image_Video, IsFinal, ProgressStatus)
    VALUES(@PlanID,@TechnicianID,GETDATE(),N'Hoàn tất lần 1, chuyển sang bước nghiệm thu',N'progress_accept_reject_final_1.jpg',N'Có',N'Chờ nghiệm thu');
    SET @ProgressID_Final_1 = SCOPE_IDENTITY();

    UPDATE PhieuYeuCauBaoTri
    SET RequestStatus = N'Chờ nghiệm thu'
    WHERE RequestID = @RequestID;

    /*9) Cập nhật vật tư thực tế sử dụng lần 1*/
    INSERT INTO VatTuThucTeSuDung(ProgressID, MaterialID, ActualQuantity, UpdateAt, Note)
    VALUES
        (@ProgressID_Final_1, 'M016', 1, GETDATE(), N'Đã dùng 1 adapter nguồn máy POS'),
        (@ProgressID_Final_1, 'M019', 1, GETDATE(), N'Đã thay SSD để kiểm tra ổn định hệ thống');

    /*10) Nghiệm thu lần 1 - BỊ TỪ CHỐI*/
    INSERT INTO NghiemThu(ApprovedByID, ProgressID, AcceptedDate,RejectReasonID, RejectNote, RejectedAt, AcceptanceStatus)
    VALUES(@ApproverID,@ProgressID_Final_1,GETDATE(),@RejectReasonID,N'Sau khi test lại, thiết bị vẫn còn lỗi nguồn chập chờn, chưa đạt điều kiện nghiệm thu.',GETDATE(),N'Từ chối nghiệm thu');

    UPDATE PhieuYeuCauBaoTri
    SET RequestStatus = N'Từ chối nghiệm thu'
    WHERE RequestID = @RequestID;

    /*11) Kỹ thuật viên quay lại thực hiện và cập nhật tiến độ lần 2 */
    UPDATE PhieuYeuCauBaoTri
    SET RequestStatus = N'Đang thực hiện'
    WHERE RequestID = @RequestID;

    INSERT INTO TienDoBaoTri(PlanID, UpdateByID, UpdateAt,ProgressDescription, Image_Video, IsFinal, ProgressStatus)
    VALUES(@PlanID,@TechnicianID,GETDATE(),N'Kiểm tra lại nguồn cấp, thay thế lại adapter và siết lại đầu nối, sau đó chạy thử lần 2',N'progress_accept_reject_working_2.jpg',N'Không',N'Đang thực hiện');
    SET @ProgressID_Working_2 = SCOPE_IDENTITY();

    INSERT INTO TienDoBaoTri(PlanID, UpdateByID, UpdateAt,ProgressDescription, Image_Video, IsFinal, ProgressStatus)
    VALUES(@PlanID,@TechnicianID,GETDATE(),N'Đã hoàn tất chỉnh sửa lại sau khi bị từ chối nghiệm thu, chờ nghiệm thu lại',N'progress_accept_reject_final_2.jpg',N'Có',N'Chờ nghiệm thu');
    SET @ProgressID_Final_2 = SCOPE_IDENTITY();

    UPDATE PhieuYeuCauBaoTri
    SET RequestStatus = N'Chờ nghiệm thu'
    WHERE RequestID = @RequestID;

    /*12) Cập nhật vật tư thực tế sử dụng lần 2*/
    INSERT INTO VatTuThucTeSuDung(ProgressID, MaterialID, ActualQuantity, UpdateAt, Note)
    VALUES
        (@ProgressID_Final_2, 'M016', 1, GETDATE(), N'Kiểm tra và thay lại adapter nguồn lần 2'),
        (@ProgressID_Final_2, 'M019', 1, GETDATE(), N'Kiểm tra lại SSD và khởi động hệ thống lần 2');

    /*13) Nghiệm thu lần 2*/
    INSERT INTO NghiemThu(ApprovedByID, ProgressID, AcceptedDate,RejectReasonID, RejectNote, RejectedAt, AcceptanceStatus)
    VALUES(@ApproverID,@ProgressID_Final_2,GETDATE(),NULL,NULL,NULL,N'Đã nghiệm thu');

    UPDATE PhieuYeuCauBaoTri
    SET RequestStatus = N'Đã nghiệm thu'
    WHERE RequestID = @RequestID;

    /*14) Đóng phiếu*/
    UPDATE PhieuYeuCauBaoTri
    SET RequestStatus = N'Hoàn thành'
    WHERE RequestID = @RequestID;

    COMMIT TRAN;

    /*A. Thông tin tổng hợp của phiếu yêu cầu và các bảng nghiệp vụ phía sau*/
    SELECT
        yc.RequestID,
        yc.RequestStatus,
        yc.RequestedDate,
        yc.MaintenanceType,
        yc.PriorityLevel,
        tb.ItemName,
        pc.CurrentAssignmentStatus,
        ks.SurveyID,
        ks.SurveyStatus,
        planLatest.PlanID,
        planLatest.PlanStatus,
        pa.MethodName,
        tdWorking.ProgressID AS WorkingProgressID,
        tdWorking.ProgressStatus AS WorkingProgressStatus,
        tdFinal.ProgressID AS FinalProgressID,
        tdFinal.ProgressStatus AS FinalProgressStatus,
        nt.AcceptanceID,
        nt.AcceptanceStatus
    FROM PhieuYeuCauBaoTri yc
    LEFT JOIN ThietBi tb ON tb.ItemID = yc.ItemID
    OUTER APPLY
    (
        SELECT TOP 1
            pc1.AssignmentStatus AS CurrentAssignmentStatus
        FROM PhanCongKyThuatVien pc1
        WHERE pc1.RequestID = yc.RequestID
        ORDER BY pc1.AssignmentID DESC
    ) pc
    LEFT JOIN KetQuaKhaoSat ks ON ks.RequestID = yc.RequestID
    OUTER APPLY
    (
        SELECT TOP 1
            kh1.PlanID,
            kh1.PlanStatus
        FROM KeHoachBaoTri kh1
        WHERE kh1.SurveyID = ks.SurveyID
        ORDER BY kh1.PlanID DESC
    ) planLatest
    LEFT JOIN PhuongAnCuaKeHoach pak ON pak.PlanID = planLatest.PlanID
    LEFT JOIN PhuongAn pa ON pa.MethodID = pak.MethodID
    OUTER APPLY
    (
        SELECT TOP 1
            td1.ProgressID,
            td1.ProgressStatus
        FROM TienDoBaoTri td1
        WHERE td1.PlanID = planLatest.PlanID
          AND td1.ProgressStatus = N'Đang thực hiện'
        ORDER BY td1.ProgressID DESC
    ) tdWorking
    OUTER APPLY
    (
        SELECT TOP 1
            td2.ProgressID,
            td2.ProgressStatus
        FROM TienDoBaoTri td2
        WHERE td2.PlanID = planLatest.PlanID
          AND td2.ProgressStatus = N'Chờ nghiệm thu'
        ORDER BY td2.ProgressID DESC
    ) tdFinal
    LEFT JOIN NghiemThu nt ON nt.ProgressID = tdFinal.ProgressID
    WHERE yc.RequestID = @RequestID;

    /*B. Lịch sử nghiệm thu*/
    SELECT
        nt.AcceptanceID,
        yc.RequestID,
        td.ProgressID,
        COALESCE(nvUpdate.FullName, ktvUpdate.TechnicianID) AS ProgressUpdatedByName,
        td.UpdateAt AS ProgressUpdateAt,
        COALESCE(nvApprover.FullName, ktvApprover.TechnicianID) AS ApproverName,
        nt.AcceptedDate,
        nt.RejectReasonID,
        rr.RejectReasonName,
        nt.RejectNote,
        nt.RejectedAt,
        nt.AcceptanceStatus
    FROM NghiemThu nt
    INNER JOIN TienDoBaoTri td ON td.ProgressID = nt.ProgressID
    INNER JOIN KeHoachBaoTri kh ON kh.PlanID = td.PlanID
    INNER JOIN KetQuaKhaoSat ks ON ks.SurveyID = kh.SurveyID
    INNER JOIN PhieuYeuCauBaoTri yc ON yc.RequestID = ks.RequestID
    LEFT JOIN KyThuatVien ktvUpdate ON ktvUpdate.TechnicianID = td.UpdateByID
    LEFT JOIN NhanVien nvUpdate ON nvUpdate.EmployeeID = ktvUpdate.EmployeeID
    LEFT JOIN KyThuatVien ktvApprover ON ktvApprover.TechnicianID = nt.ApprovedByID
    LEFT JOIN NhanVien nvApprover ON nvApprover.EmployeeID = ktvApprover.EmployeeID
    LEFT JOIN LyDoTuChoi rr ON rr.RejectReasonID = nt.RejectReasonID
    WHERE yc.RequestID = @RequestID
    ORDER BY nt.AcceptanceID;

    /*C. Lịch sử tiến độ*/
    SELECT
        td.ProgressID,
        td.PlanID,
        td.UpdateByID,
        COALESCE(nvUpdate.FullName, ktvUpdate.TechnicianID) AS UpdateByName,
        td.UpdateAt,
        td.ProgressDescription,
        td.IsFinal,
        td.ProgressStatus
    FROM TienDoBaoTri td
    LEFT JOIN KyThuatVien ktvUpdate ON ktvUpdate.TechnicianID = td.UpdateByID
    LEFT JOIN NhanVien nvUpdate ON nvUpdate.EmployeeID = ktvUpdate.EmployeeID
    WHERE td.PlanID = @PlanID
    ORDER BY td.ProgressID;

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN;

    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH;

