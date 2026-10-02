# Web-based Hotel Reservation System for Weddings

SE2030 Software Engineering &mdash; Group 2026-Y2-S1-MLB-B4G2-08

A deliberately **simple**, student-friendly implementation: Spring Boot (MVC only, no Spring Data/JPA),
plain **JDBC** against **Microsoft SQL Server**, and classic **JSP** views with a separate dashboard per role.

---

## 1. Project layout (matches what you asked for)

```
wedding-system/
 ├─ db/schema.sql                     <- run this in SSMS first
 ├─ pom.xml
 └─ src/main/
     ├─ java/com/wedding/system/
     │   ├─ model/          <- ALL entity classes (POJOs) live here
     │   ├─ repository/     <- ALL JDBC/DAO classes live here (Repository<T,ID> + impls)
     │   ├─ service/        <- business logic (cost calc, guest codes, refund rules...)
     │   ├─ controller/     <- Spring MVC controllers, one per dashboard/role
     │   ├─ config/         <- DBConnectionManager (plain JDBC connection)
     │   ├─ exception/      <- DatabaseException
     │   └─ util/           <- GuestCodeGenerator
     ├─ resources/application.properties
     └─ webapp/
         ├─ resources/css/style.css
         └─ WEB-INF/views/
             ├─ common/       (login, register, navbar)
             ├─ couple/
             ├─ guest/
             ├─ vendor/
             ├─ vendorrelations/
             ├─ hotelmanager/
             ├─ coordinator/
             ├─ finance/
             └─ admin/
```

Every dashboard is a **separate set of JSPs and a separate Controller**, so each role only ever
sees their own screens after login.

---

## 2. Setup

### Step 1 — Database
1. Install/open SQL Server (Express is fine) and SSMS or Azure Data Studio.
2. Open `db/schema.sql` and run the whole script. It creates the `WeddingSystemDB` database,
   every table, one **view**, one **scalar function**, one **stored procedure**, one **trigger**,
   and some demo seed data.
3. All demo accounts use the password **`password123`**:

   | Username     | Role                     |
   |--------------|--------------------------|
   | admin        | ADMIN                    |
   | opsmanager   | HOTEL_MANAGER            |
   | coordinator  | COORDINATOR              |
   | finance      | FINANCE_MANAGER          |
   | vendorrel    | VENDOR_RELATIONS         |
   | couple1      | COUPLE                   |
   | vendor1      | VENDOR (already approved)|

### Step 2 — Point the app at your database
Edit `src/main/resources/application.properties`:
```
db.url=jdbc:sqlserver://localhost:1433;databaseName=WeddingSystemDB;encrypt=true;trustServerCertificate=true
db.username=sa
db.password=YourStrong@Passw0rd
```

### Step 3 — Run it
**Option A — from your IDE (Eclipse / IntelliJ), easiest for a JSP + Spring Boot project:**
Import as a Maven project, then run `WeddingSystemApplication.java` as a Java application.

**Option B — command line:**
```
mvn spring-boot:run
```
Then open **http://localhost:8080/login**

**Option C — classic WAR deploy (if your IDE/server setup expects this):**
```
mvn clean package
```
Deploy the generated `target/wedding-system.war` to an external Tomcat's `webapps/` folder.

---

## 3. How each requirement maps to the code

| Your requirement | Where it lives |
|---|---|
| Guest added one-by-one, auto random guest code | `GuestController.addGuest` → `GuestService.addGuest` → `util/GuestCodeGenerator` |
| Guest logs in with guest code, RSVPs | `GuestController` (`/guest/login`, `/guest/rsvp`) — no username/password table row at all |
| Notifications only shown on login, no external channel | `NotificationRepository.readAndMarkReadForUser/Guest` — rows are only ever read inside a dashboard controller, nothing emails/SMSes anything |
| Vendor signs up, waits for requests | `VendorController.signup` (creates PENDING vendor) → `VendorRelationsController.approve` → couple selects vendor at booking time (`CoupleController.book`) → vendor sees it in `/vendor/dashboard` |
| Coordinator sees all bookings, builds timeline, couple can accept/request change | `CoordinatorController` + `CoupleController.timeline/acceptTimeline/requestChange` |
| Admin creates/deletes halls | `AdminController` (`/admin/halls/create`, `/admin/halls/{id}/delete` — delete = deactivate so past bookings stay valid) |
| Separate dashboard per role | One controller + one JSP folder per role, session `role` decides where `/login` redirects to (`AuthController.dashboardFor`) |

---

## 4. DBMS module concepts demonstrated in `db/schema.sql`

- **DDL & constraints** — every table, `CHECK` constraints, `FOREIGN KEY`s
- **VIEW** — `vw_BookingSummary` (joins Bookings + WeddingHalls + Users)
- **Scalar FUNCTION** — `fn_GuestHeadcount` (accepted guests + plus-ones)
- **Stored PROCEDURE** — `sp_UpdateBookingStatus` (approve/reject + auto-generate invoice)
- **TRIGGER** — `trg_Bookings_NotifyOnConfirm` (auto-creates the couple's notification)
- **Database connectivity from Java** — `DBConnectionManager` + every Repository uses
  `PreparedStatement`/`CallableStatement`, try-with-resources, and a custom checked
  `DatabaseException` for error handling (matches Module 11).

## 5. OOP concepts demonstrated

See the Javadoc comments at the top of `Repository.java`, `DatabaseException.java`,
`User.java`, `UserRepository.java`, and every `Service` class — each one calls out exactly
which OOP concept (encapsulation, abstraction, inheritance, polymorphism, composition,
generics) it illustrates, so you can explain it directly in your viva.

---

## 6. Known simplifications (documented on purpose, mention these in your report)

- Passwords are stored in plain text — acceptable for an academic prototype, call it out as a
  "future improvement" in your final report if your rubric expects security best practice.
- Payment is a simulated flow (no real payment gateway), per the assignment's own scope note.
- One hotel property only (no multi-branch support).
