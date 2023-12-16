from connecter import Firebase

fb = Firebase()
database = fb.getDatabase()

def assign(info):

    data = info.split('_')

    dept = data[0]
    year = data[1]

    # Retrieve the student data from Firebase
    students = database.get().val()["Users"][dept][year]

    # Sort the student data by full name
    sorted_students = sorted(students.values(), key=lambda s: s['name'])

    # Assign roll numbers to each student
    for i, student in enumerate(sorted_students, start=1):
        student['roll_no'] = i

    # Update the Firebase database with the updated student data
    for student in sorted_students:
        database.child("College").child("Department").child(dept).child(year).child("Students").child(student['uid']).set({
            'r_no': student['roll_no'],
            'name': student['name'],
            'prn': student['prn'],
            'uid': student['uid'],
        })

assign('Computer Engineering_Final Year')