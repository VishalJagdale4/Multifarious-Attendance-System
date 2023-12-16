print('Importing Attendance Marker... ', end='')

def mark(list, mark_to, database):
    database.child(f'Attendance/{mark_to[0]}/{mark_to[1]}/{mark_to[2]}/{mark_to[3]}/present').update(
        {student:'' for student in list}
    )

print('OK')