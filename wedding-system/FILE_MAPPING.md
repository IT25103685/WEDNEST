# File → Major Function Mapping (grouped by layer)
### Web-based Hotel Reservation System for Weddings — Group 2026-Y2-S1-MLB-B4G2-08

Reference used: Section 7 "Six Major Functions" of the Proposal Document.

**Update:** the original `CoupleController.java` handled 5 of the 6 major functions in one
file. It has now been **split into 5 separate controllers** (`CoupleBookingController`,
`CouplePackageController`, `CoupleGuestController`, `CouplePaymentController`,
`CoupleTimelineController`) so every file below belongs to exactly one Major Function —
no shared files, no notes needed.

---

## 1. Venue / Hall Booking & Availability Management
*Owner (proposal): De Zoysa G.A.L.C.*

**Controller**
* `controller/CoupleBookingController.java` — couple's dashboard, venue search, booking creation
* `controller/HotelManagerController.java` — Hotel Operations Manager's approve/reject workflow

**Model**
* `model/Booking.java`
* `model/WeddingHall.java`

**Repository**
* `repository/BookingRepository.java`
* `repository/WeddingHallRepository.java`

**Service**
* `service/BookingService.java`
* `service/HallService.java`

**Frontend / JSP**
* `couple/dashboard.jsp`
* `couple/search-venues.jsp`
* `couple/book.jsp`
* `couple/booking-detail.jsp`
* `hotelmanager/dashboard.jsp`

---

## 2. Wedding Package Customization
*Owner (proposal): Wijayanayaka K. W. S. S. A.*

**Controller**
* `controller/CouplePackageController.java`

**Model**
* `model/WeddingPackage.java`

**Repository**
* `repository/WeddingPackageRepository.java`

**Service**
* `service/PackageService.java`

**Frontend / JSP**
* `couple/customize-package.jsp`

---

## 3. Guest List & RSVP Management
*Owner (proposal): Karunathilaka P. M.*

**Controller**
* `controller/CoupleGuestController.java` — couple adds guests
* `controller/GuestController.java` — guest-code login + RSVP submission

**Model**
* `model/Guest.java`

**Repository**
* `repository/GuestRepository.java`

**Service**
* `service/GuestService.java`
* `util/GuestCodeGenerator.java` *(utility, not a service, but core to this function — generates each guest's random code)*

**Frontend / JSP**
* `couple/guest-list.jsp`
* `guest/login.jsp`
* `guest/invitation.jsp`

---

## 4. Payment & Billing Management
*Owner (proposal): Kariyawasam S.S.*

**Controller**
* `controller/CouplePaymentController.java` — couple's invoice view + payments + cancellation request
* `controller/FinanceController.java` — Finance and Billing Manager's overdue monitoring + refund processing

**Model**
* `model/Invoice.java`
* `model/Payment.java`

**Repository**
* `repository/InvoiceRepository.java`
* `repository/PaymentRepository.java`

**Service**
* `service/PaymentService.java`

**Frontend / JSP**
* `couple/payment.jsp`
* `finance/dashboard.jsp`
* `finance/invoice-detail.jsp`
* `finance/refund.jsp`

---

## 5. Event Scheduling & Timeline Coordination
*Owner (proposal): Herath H. M. H. S.*

**Controller**
* `controller/CoupleTimelineController.java` — couple views/accepts/requests changes to the timeline
* `controller/CoordinatorController.java` — coordinator builds and publishes the timeline

**Model**
* `model/WeddingTimeline.java`
* `model/TimelineEvent.java`

**Repository**
* `repository/WeddingTimelineRepository.java`
* `repository/TimelineEventRepository.java`

**Service**
* `service/TimelineService.java`

**Frontend / JSP**
* `couple/timeline.jsp`
* `coordinator/dashboard.jsp`
* `coordinator/timeline-builder.jsp`

---

## 6. Admin Dashboard & Reporting (incl. Vendor Management)
*Owner (proposal): Ashvithan A*

**Controller**
* `controller/AdminController.java` — hall create/deactivate, admin overview
* `controller/VendorController.java` — vendor signup + accept/decline requests
* `controller/VendorRelationsController.java` — vendor approval + performance rating

**Model**
* `model/Vendor.java`
* `model/VendorRequest.java`

**Repository**
* `repository/VendorRepository.java`
* `repository/VendorRequestRepository.java`

**Service**
* `service/VendorService.java`

**Frontend / JSP**
* `admin/dashboard.jsp`
* `vendor/signup.jsp`
* `vendor/dashboard.jsp`
* `vendorrelations/dashboard.jsp`

**Note**
* The couple's vendor *selection* (checkboxes on the booking form) is one call —
  `vendorService.sendRequestToVendor(...)` — made from `CoupleBookingController.book()`
  in Function 1. That single method call is the only place two major functions touch;
  everything else in this section is exclusively vendor/admin code.

---

## Common / Shared / Not Directly Related to a Major Function

These exist to make the whole application run, or support login/authentication, which the
proposal lists as a **minor** function, not one of the six majors.

**Controller**
* `controller/AuthController.java` — login/register/logout for every role

**Model**
* `model/User.java` — login account, shared by all 7 roles
* `model/Notification.java` — generic in-app notification, read by more than one function

**Repository**
* `repository/Repository.java` — generic `Repository<T,ID>` interface (pure abstraction)
* `repository/UserRepository.java`
* `repository/NotificationRepository.java`

**Service**
* `service/AuthService.java`
* `service/NotificationService.java`

**Config / Infrastructure**
* `WeddingSystemApplication.java` — Spring Boot entry point
* `config/DBConnectionManager.java` — generic JDBC connection factory
* `exception/DatabaseException.java` — generic checked exception used by every repository

**Frontend / JSP**
* `common/login.jsp`
* `common/register.jsp`
* `common/navbar.jsp`

**Other Files**
* `pom.xml` — Maven build configuration
* `application.properties` — DB/server/view-resolver configuration
* `style.css` — shared styling used by every dashboard
* `db/schema.sql` — full database schema (contains objects for all six functions in one file)
* `README.md` — setup/run documentation

---

## Complete File Mapping Table

| File | Primary Major Function | Layer | Reason |
|---|---|---|---|
| `controller/CoupleBookingController.java` | Venue / Hall Booking & Availability | Controller | Dashboard, search, booking creation |
| `controller/HotelManagerController.java` | Venue / Hall Booking & Availability | Controller | Approve/reject bookings |
| `model/Booking.java` | Venue / Hall Booking & Availability | Model | Booking record |
| `model/WeddingHall.java` | Venue / Hall Booking & Availability | Model | Hall record |
| `repository/BookingRepository.java` | Venue / Hall Booking & Availability | Repository | Booking CRUD/search |
| `repository/WeddingHallRepository.java` | Venue / Hall Booking & Availability | Repository | Hall CRUD/availability |
| `service/BookingService.java` | Venue / Hall Booking & Availability | Service | Booking business logic |
| `service/HallService.java` | Venue / Hall Booking & Availability | Service | Hall search/create/deactivate |
| `couple/dashboard.jsp` | Venue / Hall Booking & Availability | JSP | Couple's booking list |
| `couple/search-venues.jsp` | Venue / Hall Booking & Availability | JSP | Venue search UI |
| `couple/book.jsp` | Venue / Hall Booking & Availability | JSP | Booking form |
| `couple/booking-detail.jsp` | Venue / Hall Booking & Availability | JSP | Booking hub page |
| `hotelmanager/dashboard.jsp` | Venue / Hall Booking & Availability | JSP | Approval UI |
| `controller/CouplePackageController.java` | Wedding Package Customization | Controller | Package selection |
| `model/WeddingPackage.java` | Wedding Package Customization | Model | Package record |
| `repository/WeddingPackageRepository.java` | Wedding Package Customization | Repository | Package CRUD |
| `service/PackageService.java` | Wedding Package Customization | Service | Pricing/total-cost logic |
| `couple/customize-package.jsp` | Wedding Package Customization | JSP | Tier/add-on form |
| `controller/CoupleGuestController.java` | Guest List & RSVP Management | Controller | Add guest |
| `controller/GuestController.java` | Guest List & RSVP Management | Controller | Guest login/RSVP |
| `model/Guest.java` | Guest List & RSVP Management | Model | Guest record |
| `repository/GuestRepository.java` | Guest List & RSVP Management | Repository | Guest CRUD/lookup |
| `service/GuestService.java` | Guest List & RSVP Management | Service | Add guest, RSVP, headcount |
| `util/GuestCodeGenerator.java` | Guest List & RSVP Management | Utility | Random guest code generation |
| `couple/guest-list.jsp` | Guest List & RSVP Management | JSP | Guest list + add form |
| `guest/login.jsp` | Guest List & RSVP Management | JSP | Guest code entry |
| `guest/invitation.jsp` | Guest List & RSVP Management | JSP | RSVP form |
| `controller/CouplePaymentController.java` | Payment & Billing Management | Controller | Invoice/payment/cancel |
| `controller/FinanceController.java` | Payment & Billing Management | Controller | Overdue + refunds |
| `model/Invoice.java` | Payment & Billing Management | Model | Invoice record |
| `model/Payment.java` | Payment & Billing Management | Model | Payment/refund record |
| `repository/InvoiceRepository.java` | Payment & Billing Management | Repository | Invoice CRUD |
| `repository/PaymentRepository.java` | Payment & Billing Management | Repository | Payment CRUD |
| `service/PaymentService.java` | Payment & Billing Management | Service | Payments, overdue, refund calc |
| `couple/payment.jsp` | Payment & Billing Management | JSP | Invoice + pay form |
| `finance/dashboard.jsp` | Payment & Billing Management | JSP | Overdue invoice list |
| `finance/invoice-detail.jsp` | Payment & Billing Management | JSP | Payment history |
| `finance/refund.jsp` | Payment & Billing Management | JSP | Refund form |
| `controller/CoupleTimelineController.java` | Event Scheduling & Timeline Coordination | Controller | View/accept/request-change |
| `controller/CoordinatorController.java` | Event Scheduling & Timeline Coordination | Controller | Build/publish timeline |
| `model/WeddingTimeline.java` | Event Scheduling & Timeline Coordination | Model | Timeline record |
| `model/TimelineEvent.java` | Event Scheduling & Timeline Coordination | Model | Timeline event/slot |
| `repository/WeddingTimelineRepository.java` | Event Scheduling & Timeline Coordination | Repository | Timeline CRUD |
| `repository/TimelineEventRepository.java` | Event Scheduling & Timeline Coordination | Repository | Event CRUD + overlap check |
| `service/TimelineService.java` | Event Scheduling & Timeline Coordination | Service | Build/publish/change logic |
| `couple/timeline.jsp` | Event Scheduling & Timeline Coordination | JSP | Couple's timeline view |
| `coordinator/dashboard.jsp` | Event Scheduling & Timeline Coordination | JSP | Confirmed weddings list |
| `coordinator/timeline-builder.jsp` | Event Scheduling & Timeline Coordination | JSP | Add-event/publish UI |
| `controller/AdminController.java` | Admin Dashboard & Reporting | Controller | Hall create/deactivate |
| `controller/VendorController.java` | Admin Dashboard & Reporting | Controller | Vendor signup/respond |
| `controller/VendorRelationsController.java` | Admin Dashboard & Reporting | Controller | Vendor approval/rating |
| `model/Vendor.java` | Admin Dashboard & Reporting | Model | Vendor profile |
| `model/VendorRequest.java` | Admin Dashboard & Reporting | Model | Booking→vendor request |
| `repository/VendorRepository.java` | Admin Dashboard & Reporting | Repository | Vendor CRUD |
| `repository/VendorRequestRepository.java` | Admin Dashboard & Reporting | Repository | Vendor request CRUD |
| `service/VendorService.java` | Admin Dashboard & Reporting | Service | Registration/approval/rating |
| `admin/dashboard.jsp` | Admin Dashboard & Reporting | JSP | Hall management + overview |
| `vendor/signup.jsp` | Admin Dashboard & Reporting | JSP | Vendor registration |
| `vendor/dashboard.jsp` | Admin Dashboard & Reporting | JSP | Vendor's request inbox |
| `vendorrelations/dashboard.jsp` | Admin Dashboard & Reporting | JSP | Approval/rating UI |
| `controller/AuthController.java` | Common / Shared | Controller | Login/register/logout |
| `model/User.java` | Common / Shared | Model | Login account (all roles) |
| `model/Notification.java` | Common / Shared | Model | Generic notification |
| `repository/Repository.java` | Common / Shared | Interface | Generic DAO abstraction |
| `repository/UserRepository.java` | Common / Shared | Repository | Account CRUD/lookup |
| `repository/NotificationRepository.java` | Common / Shared | Repository | Notification CRUD |
| `service/AuthService.java` | Common / Shared | Service | Login/registration |
| `service/NotificationService.java` | Common / Shared | Service | Notification retrieval |
| `WeddingSystemApplication.java` | Common / Shared | Bootstrap | Spring Boot entry point |
| `config/DBConnectionManager.java` | Common / Shared | Configuration | JDBC connection factory |
| `exception/DatabaseException.java` | Common / Shared | Exception | Generic DAO exception |
| `common/login.jsp` | Common / Shared | JSP | Login screen |
| `common/register.jsp` | Common / Shared | JSP | Couple registration |
| `common/navbar.jsp` | Common / Shared | JSP | Shared nav fragment |
| `pom.xml` | Common / Shared | Build Config | Maven build |
| `application.properties` | Common / Shared | Configuration | DB/server config |
| `style.css` | Common / Shared | Stylesheet | Shared styling |
| `db/schema.sql` | Common / Shared | Database Script | Schema for all functions |
| `README.md` | Common / Shared | Documentation | Setup/run instructions |

**Total files: 79 / 79** ✅ *(75 original files − 1 merged `CoupleController.java` + 5 new split controllers = 79)*
