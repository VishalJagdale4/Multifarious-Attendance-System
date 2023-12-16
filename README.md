# Multifarious-Attendance-System
The process of recording attendance is influenced by various factors, such as the number of participants, event locations, and time intervals. It is crucial for tracking the intended audience in events or programs. In educational institutions, roll call is commonly used to record classroom attendance, but manual methods become tedious with a large number of participants. To address this, a multifarious face attendance system is implemented, incorporating machine learning and deep learning techniques like MT-CNN and VGGFace2. This system, demonstrated in educational institutions, aims to resolve issues like fraudulent attendance and proxies. By recognizing multiple faces using VGGFace2 and mapping attendance accordingly, the system allows for effective analysis of program attendees. The discovered faces are cross-referenced with the student face database, ensuring accurate attendance records and efficient management of attendees.

## Technology used:
This attendance system project is developed using a technology stack that includes Flutter, Firebase, and Python. Flutter is utilized for the frontend, providing a cross-platform mobile application with a rich user interface. Firebase, a cloud-based platform, serves as the backend for real-time data storage and synchronization. Python is employed for the implementation of machine learning and deep learning aspects, incorporating models such as MT-CNN and VGGFace2 for face

### Login Page
The project incorporates a login page as its initial step. Users, including students, faculty, and administrators, are required to log in with their specific credentials. Each user has a dedicated login page accessible through the interface, as illustrated in figure.

![20230328_012514](https://github.com/VishalJagdale4/Multifarious-Attendance-System/assets/85816586/3fcb31c5-24ab-4d5d-94b5-28b2651cb5e4)

### Faculty Section
The faculty interface, shown in figure, allows easy attendance management. Faculty can select class details, click "Take Attendance" to capture attendee images using the camera interface, and then upload the images to the database by clicking "Done." Streamlining the process for efficient attendance tracking.

![20230328_012250](https://github.com/VishalJagdale4/Multifarious-Attendance-System/assets/85816586/d305bede-36b1-49a0-b2a3-0f1a3cd53399)

### Attendance Report Generation Section
Faculty/Admins can generate attendance reports, and students can access statistical reports for their own attendance. Enhances transparency and insight for all users.

![Screenshot_2023-03-28-01-04-24-793_com vishal project](https://github.com/VishalJagdale4/Multifarious-Attendance-System/assets/85816586/27d22bf5-6ea6-4368-a368-01aa45f60a02)

### Admin Section
The proposed system efficiently manages student and faculty profiles, validated and verified by the Admin. Admin actions include adding/updating profiles and verifying biometric data for accuracy.

![20230328_012658](https://github.com/VishalJagdale4/Multifarious-Attendance-System/assets/85816586/c88e4c42-9dba-41c8-a9ba-2741e15b80cd)

### Student Section
Admin actions include adding/updating profiles and verifying biometric data for accuracy. Students can track attendance and view statistics. To register, attendees upload four face images, stored in the database. Admin/Faculty validates and adds images to the facial recognition model for identification.

![20230328_012833](https://github.com/VishalJagdale4/Multifarious-Attendance-System/assets/85816586/9cda7814-1cfb-484c-a960-663d1ccee5c5)

### Database View
The system generates insightful attendance reports, detailing attendance data like who, when, and frequency. It offers attendance summary, course, and class reports, with customizable options. Users can share reports with students' parents as needed.

![Screenshot_20230227_104105](https://github.com/VishalJagdale4/Multifarious-Attendance-System/assets/85816586/42b31d0c-5875-4c17-9de5-feef3dd3d3e6)

### Activity Diagram

![Final Year Project (1)](https://github.com/VishalJagdale4/Multifarious-Attendance-System/assets/85816586/944035be-8a79-42ea-b179-8ee91b53c0e0)

### Face Detection (MT_CNN)
The system utilizes the MTCNN face detection algorithm to detect and extract faces from images.

![Add a subheading (3)](https://github.com/VishalJagdale4/Multifarious-Attendance-System/assets/85816586/fc397316-9dd3-406c-9213-5c7bc2cf97de)

### Face Recognition (VGGFACE2)
VGGFace algorithm for individual student recognition.

![Add a subheading](https://github.com/VishalJagdale4/Multifarious-Attendance-System/assets/85816586/16ad1ee3-6460-48ef-9638-7abc8104d2de)

For more about the project you can read out this IEEE Paper of [Multifarious Face Attendance System using Machine Learning and Deep Learning](https://ieeexplore.ieee.org/document/10142759).
