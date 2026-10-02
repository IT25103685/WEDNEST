/* ============================================================================
   Web-based Hotel Reservation System for Weddings
   Microsoft SQL Server DDL script
   Group :- 2026-Y2-S1-MLB-B4G2-08

   Run this whole script in SQL Server Management Studio (SSMS) / Azure Data
   Studio against a fresh SQL Server instance. It will:
     1. Create the WeddingSystemDB database
     2. Create every table with primary/foreign keys and constraints
     3. Create one VIEW, one scalar FUNCTION, one STORED PROCEDURE and one
        TRIGGER (Database Programming module requirements)
     4. Insert a small amount of seed/demo data so you can log in immediately
   ============================================================================ */

IF DB_ID('WeddingSystemDB') IS NULL
    CREATE DATABASE WeddingSystemDB;
GO

USE WeddingSystemDB;
GO

/* ---------------------------------------------------------------------------
   1. TABLES
   --------------------------------------------------------------------------- */

IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE dbo.Users;
CREATE TABLE Users (
    Id          INT IDENTITY(1,1) PRIMARY KEY,
    FullName    NVARCHAR(100) NOT NULL,
    Email       NVARCHAR(100) NOT NULL,
    Phone       NVARCHAR(20)  NULL,
    Username    NVARCHAR(50)  NOT NULL UNIQUE,
    Password    NVARCHAR(100) NOT NULL,
    Role        NVARCHAR(30)  NOT NULL
        CHECK (Role IN ('COUPLE','HOTEL_MANAGER','COORDINATOR','FINANCE_MANAGER',
                         'VENDOR_RELATIONS','VENDOR','ADMIN'))
);
GO

IF OBJECT_ID('dbo.WeddingHalls', 'U') IS NOT NULL DROP TABLE dbo.WeddingHalls;
CREATE TABLE WeddingHalls (
    Id             INT IDENTITY(1,1) PRIMARY KEY,
    Name           NVARCHAR(100) NOT NULL,
    Location       NVARCHAR(150) NOT NULL,
    CapacityMax    INT NOT NULL CHECK (CapacityMax > 0),
    PricePerEvent  DECIMAL(12,2) NOT NULL CHECK (PricePerEvent >= 0),
    IsActive       BIT NOT NULL DEFAULT 1
);
GO

IF OBJECT_ID('dbo.Bookings', 'U') IS NOT NULL DROP TABLE dbo.Bookings;
CREATE TABLE Bookings (
    Id                  INT IDENTITY(1,1) PRIMARY KEY,
    CoupleId            INT NOT NULL FOREIGN KEY REFERENCES Users(Id),
    HallId              INT NOT NULL FOREIGN KEY REFERENCES WeddingHalls(Id),
    EventDate           DATE NOT NULL,
    ExpectedGuestCount  INT NOT NULL CHECK (ExpectedGuestCount > 0),
    Status              NVARCHAR(20) NOT NULL DEFAULT 'PENDING_APPROVAL'
        CHECK (Status IN ('PENDING_APPROVAL','CONFIRMED','REJECTED','CANCELLED'))
);
GO

IF OBJECT_ID('dbo.WeddingPackages', 'U') IS NOT NULL DROP TABLE dbo.WeddingPackages;
CREATE TABLE WeddingPackages (
    Id            INT IDENTITY(1,1) PRIMARY KEY,
    BookingId     INT NOT NULL FOREIGN KEY REFERENCES Bookings(Id) ON DELETE CASCADE,
    Tier          NVARCHAR(20) NOT NULL CHECK (Tier IN ('STANDARD','PREMIUM','LUXURY')),
    Catering      BIT NOT NULL DEFAULT 0,
    Decoration    BIT NOT NULL DEFAULT 0,
    Photography   BIT NOT NULL DEFAULT 0,
    Music         BIT NOT NULL DEFAULT 0,
    TotalCost     DECIMAL(12,2) NOT NULL DEFAULT 0
);
GO

IF OBJECT_ID('dbo.Guests', 'U') IS NOT NULL DROP TABLE dbo.Guests;
CREATE TABLE Guests (
    Id                    INT IDENTITY(1,1) PRIMARY KEY,
    BookingId             INT NOT NULL FOREIGN KEY REFERENCES Bookings(Id) ON DELETE CASCADE,
    Name                  NVARCHAR(100) NOT NULL,
    Contact               NVARCHAR(100) NULL,
    Category              NVARCHAR(30)  NULL,      -- family, friend, colleague...
    GuestCode             NVARCHAR(10)  NOT NULL UNIQUE,
    RsvpStatus            NVARCHAR(20) NOT NULL DEFAULT 'PENDING'
        CHECK (RsvpStatus IN ('PENDING','ACCEPTED','DECLINED')),
    DietaryRestrictions   NVARCHAR(200) NULL,
    PlusOne               BIT NOT NULL DEFAULT 0,
    FamilyMembersCount    INT NOT NULL DEFAULT 1
);
GO

IF OBJECT_ID('dbo.Invoices', 'U') IS NOT NULL DROP TABLE dbo.Invoices;
CREATE TABLE Invoices (
    Id            INT IDENTITY(1,1) PRIMARY KEY,
    BookingId     INT NOT NULL FOREIGN KEY REFERENCES Bookings(Id) ON DELETE CASCADE,
    TotalAmount   DECIMAL(12,2) NOT NULL DEFAULT 0,
    PaidAmount    DECIMAL(12,2) NOT NULL DEFAULT 0,
    Status        NVARCHAR(20) NOT NULL DEFAULT 'UNPAID'
        CHECK (Status IN ('UNPAID','PARTIAL','PAID'))
);
GO

IF OBJECT_ID('dbo.Payments', 'U') IS NOT NULL DROP TABLE dbo.Payments;
CREATE TABLE Payments (
    Id            INT IDENTITY(1,1) PRIMARY KEY,
    InvoiceId     INT NOT NULL FOREIGN KEY REFERENCES Invoices(Id) ON DELETE CASCADE,
    Amount        DECIMAL(12,2) NOT NULL CHECK (Amount > 0),
    Method        NVARCHAR(30) NOT NULL,
    PaymentDate   DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

IF OBJECT_ID('dbo.Vendors', 'U') IS NOT NULL DROP TABLE dbo.Vendors;
CREATE TABLE Vendors (
    Id             INT IDENTITY(1,1) PRIMARY KEY,
    UserId         INT NOT NULL FOREIGN KEY REFERENCES Users(Id) ON DELETE CASCADE,
    CompanyName    NVARCHAR(100) NOT NULL,
    Category       NVARCHAR(30) NOT NULL
        CHECK (Category IN ('CATERER','PHOTOGRAPHER','DECORATOR','DJ','MAKEUP_ARTIST','CAKE','TRANSPORT')),
    Status         NVARCHAR(20) NOT NULL DEFAULT 'PENDING'
        CHECK (Status IN ('PENDING','APPROVED','REJECTED')),
    ContractTerms  NVARCHAR(300) NULL,
    Rating         DECIMAL(3,2) NOT NULL DEFAULT 0
);
GO

IF OBJECT_ID('dbo.VendorRequests', 'U') IS NOT NULL DROP TABLE dbo.VendorRequests;
CREATE TABLE VendorRequests (
    Id                 INT IDENTITY(1,1) PRIMARY KEY,
    BookingId          INT NOT NULL FOREIGN KEY REFERENCES Bookings(Id) ON DELETE CASCADE,
    VendorId           INT NOT NULL FOREIGN KEY REFERENCES Vendors(Id),
    EventDescription   NVARCHAR(400) NOT NULL,
    EventDate          DATE NOT NULL,
    Status             NVARCHAR(20) NOT NULL DEFAULT 'PENDING'
        CHECK (Status IN ('PENDING','ACCEPTED','DECLINED'))
);
GO

IF OBJECT_ID('dbo.WeddingTimelines', 'U') IS NOT NULL DROP TABLE dbo.WeddingTimelines;
CREATE TABLE WeddingTimelines (
    Id                     INT IDENTITY(1,1) PRIMARY KEY,
    BookingId              INT NOT NULL FOREIGN KEY REFERENCES Bookings(Id) ON DELETE CASCADE,
    CoordinatorId          INT NOT NULL FOREIGN KEY REFERENCES Users(Id),
    Status                 NVARCHAR(20) NOT NULL DEFAULT 'DRAFT'
        CHECK (Status IN ('DRAFT','PUBLISHED','CHANGE_REQUESTED')),
    ChangeRequestMessage   NVARCHAR(400) NULL
);
GO

IF OBJECT_ID('dbo.TimelineEvents', 'U') IS NOT NULL DROP TABLE dbo.TimelineEvents;
CREATE TABLE TimelineEvents (
    Id           INT IDENTITY(1,1) PRIMARY KEY,
    TimelineId   INT NOT NULL FOREIGN KEY REFERENCES WeddingTimelines(Id) ON DELETE CASCADE,
    EventName    NVARCHAR(100) NOT NULL,
    StartTime    DATETIME2 NOT NULL,
    EndTime      DATETIME2 NOT NULL,
    VendorId     INT NULL FOREIGN KEY REFERENCES Vendors(Id),
    CHECK (EndTime > StartTime)
);
GO

IF OBJECT_ID('dbo.Notifications', 'U') IS NOT NULL DROP TABLE dbo.Notifications;
CREATE TABLE Notifications (
    Id          INT IDENTITY(1,1) PRIMARY KEY,
    UserId      INT NULL FOREIGN KEY REFERENCES Users(Id) ON DELETE CASCADE,
    GuestId     INT NULL FOREIGN KEY REFERENCES Guests(Id) ON DELETE CASCADE,
    Message     NVARCHAR(300) NOT NULL,
    IsRead      BIT NOT NULL DEFAULT 0,
    CreatedAt   DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CHECK ( (UserId IS NOT NULL AND GuestId IS NULL) OR (UserId IS NULL AND GuestId IS NOT NULL) )
);
GO

/* ---------------------------------------------------------------------------
   2. VIEW - vw_BookingSummary
   Joins Bookings + WeddingHalls + Users so the BookingRepository.readAll()
   can pull a human-readable list (hall name, couple name) in a single query
   instead of the app doing the joining.
   --------------------------------------------------------------------------- */
IF OBJECT_ID('dbo.vw_BookingSummary', 'V') IS NOT NULL DROP VIEW dbo.vw_BookingSummary;
GO
CREATE VIEW vw_BookingSummary AS
SELECT
    b.Id, b.CoupleId, b.HallId, b.EventDate, b.ExpectedGuestCount, b.Status,
    h.Name AS HallName,
    u.FullName AS CoupleName
FROM Bookings b
JOIN WeddingHalls h ON b.HallId = h.Id
JOIN Users u ON b.CoupleId = u.Id;
GO

/* ---------------------------------------------------------------------------
   3. SCALAR FUNCTION - fn_GuestHeadcount
   Returns the total headcount for a booking: every ACCEPTED guest, plus one
   extra head for each ACCEPTED guest who brought a plus-one.
   --------------------------------------------------------------------------- */
IF OBJECT_ID('dbo.fn_GuestHeadcount', 'FN') IS NOT NULL DROP FUNCTION dbo.fn_GuestHeadcount;
GO
CREATE FUNCTION fn_GuestHeadcount (@BookingId INT)
RETURNS INT
AS
BEGIN
    DECLARE @Headcount INT;
    SELECT @Headcount =
        SUM(FamilyMembersCount) + SUM(CASE WHEN PlusOne = 1 THEN 1 ELSE 0 END)
    FROM Guests
    WHERE BookingId = @BookingId AND RsvpStatus = 'ACCEPTED';

    RETURN ISNULL(@Headcount, 0);
END;
GO

/* ---------------------------------------------------------------------------
   4. STORED PROCEDURE - sp_UpdateBookingStatus
   Used when the Hotel Operations Manager approves/rejects a booking. When a
   booking becomes CONFIRMED, this also auto-creates the itemized invoice
   (0 paid so far) so Payment & Billing has something to work with straight
   away - mirrors the "System generates an itemized invoice once the package
   is confirmed" step in the spec.
   --------------------------------------------------------------------------- */
IF OBJECT_ID('dbo.sp_UpdateBookingStatus', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_UpdateBookingStatus;
GO
CREATE PROCEDURE sp_UpdateBookingStatus
    @BookingId INT,
    @NewStatus NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Bookings SET Status = @NewStatus WHERE Id = @BookingId;

    IF @NewStatus = 'CONFIRMED' AND NOT EXISTS (SELECT 1 FROM Invoices WHERE BookingId = @BookingId)
    BEGIN
        DECLARE @PackageCost DECIMAL(12,2);
        SELECT @PackageCost = TotalCost FROM WeddingPackages WHERE BookingId = @BookingId;

        INSERT INTO Invoices (BookingId, TotalAmount, PaidAmount, Status)
        VALUES (@BookingId, ISNULL(@PackageCost, 0), 0, 'UNPAID');
    END
END;
GO

/* ---------------------------------------------------------------------------
   5. TRIGGER - trg_Bookings_NotifyOnConfirm
   Whenever a booking's status changes to CONFIRMED, automatically drop a
   Notification row for the couple ("your booking is confirmed"). This is
   what makes the "System sends a confirmation notification to the Couple
   through website (when they log in)" step work without any external
   email/SMS service.
   --------------------------------------------------------------------------- */
IF OBJECT_ID('dbo.trg_Bookings_NotifyOnConfirm', 'TR') IS NOT NULL DROP TRIGGER dbo.trg_Bookings_NotifyOnConfirm;
GO
CREATE TRIGGER trg_Bookings_NotifyOnConfirm
ON Bookings
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Notifications (UserId, GuestId, Message)
    SELECT i.CoupleId, NULL,
           N'Your booking #' + CAST(i.Id AS NVARCHAR(10)) + N' has been CONFIRMED. The venue is now reserved for your date.'
    FROM inserted i
    JOIN deleted d ON i.Id = d.Id
    WHERE i.Status = 'CONFIRMED' AND d.Status <> 'CONFIRMED';
END;
GO

/* ---------------------------------------------------------------------------
   6. SEED DATA - lets you log in immediately after running this script.
   All demo passwords are: password123
   --------------------------------------------------------------------------- */
INSERT INTO Users (FullName, Email, Phone, Username, Password, Role) VALUES
('Hotel Admin', 'admin@hotel.com', '0770000001', 'admin', 'password123', 'ADMIN'),
('Nadeesha Perera (Hotel Ops)', 'ops@hotel.com', '0770000002', 'opsmanager', 'password123', 'HOTEL_MANAGER'),
('Sanduni Fernando (Coordinator)', 'coordinator@hotel.com', '0770000003', 'coordinator', 'password123', 'COORDINATOR'),
('Kasun Silva (Finance)', 'finance@hotel.com', '0770000004', 'finance', 'password123', 'FINANCE_MANAGER'),
('Dilani Jayasuriya (Vendor Relations)', 'vendorrel@hotel.com', '0770000005', 'vendorrel', 'password123', 'VENDOR_RELATIONS'),
('Amal & Nimasha (Couple)', 'couple@example.com', '0771111111', 'couple1', 'password123', 'COUPLE'),
('Royal Photography', 'contact@royalphoto.com', '0772222222', 'vendor1', 'password123', 'VENDOR');
GO

INSERT INTO WeddingHalls (Name, Location, CapacityMax, PricePerEvent, IsActive) VALUES
('Grand Ballroom', 'Colombo 03', 500, 350000.00, 1),
('Garden Pavilion', 'Colombo 07', 250, 220000.00, 1),
('Crystal Hall', 'Mount Lavinia', 350, 280000.00, 1);
GO

INSERT INTO Vendors (UserId, CompanyName, Category, Status, ContractTerms, Rating)
SELECT Id, 'Royal Photography', 'PHOTOGRAPHER', 'APPROVED', 'Standard 1-year contract, 20% advance', 4.5
FROM Users WHERE Username = 'vendor1';
GO

PRINT 'WeddingSystemDB schema created successfully.';
