from connecter import Firebase
from datetime import datetime
import pandas as pd
import time
import csv
import os

#firebase
fb = Firebase()
database = fb.getDatabase()
storage = fb.getStorage()

def format_date(date_str):
    date = datetime.strptime(date_str, '%Y/%m/%d')
    formatted_date = date.strftime('%#d %B %Y')
    return formatted_date

def download_csvs(root_path, start, end):

    start_date = datetime.strptime(start, "%d %B %Y")
    end_date = datetime.strptime(end, "%d %B %Y")

    for path in storage.child(root_path).list_files():
        storage.path = ''
        if path.name.endswith('.csv'):
            path_date_str = path.name.split("/")[-3] 
            path_date = datetime.strptime(path_date_str, "%d %B %Y")
            if start_date <= path_date <= end_date:
                filename = f'csvs/{os.path.basename(path.name)}'
                storage.child(path.name).download(filename)

def daily_report(info):

    data = info.split('_')

    dept = data[0]
    year = data[1]
    day = data[3]
    course = data[2]

    if (day not in database.get().val()['Attendance'][dept][year]):
        return None

    attendance = database.get().val()['Attendance'][dept][year][day][course]['present']
    
    if attendance is None:
        return None

    all_students = database.get().val()['College']['Department'][dept][year]['Students']

    df = pd.DataFrame.from_dict(all_students, orient='index')

    df["Attendance"] = df.index.map(lambda x: 1 if x in attendance else 0)
    df = df[["r_no", "name", "prn", "Attendance"]]
    df = df.sort_values("r_no")
    csv = f"{day}_{course}.csv"
    df.to_csv(csv, index=False, header=True)

    stg_ref = storage.child(f"Attendance Reports/{dept}/{year}/{day}/{course}/{csv}")
    
    stg_ref.put(csv)

    os.remove(csv)

    storage.path = ''

    url = stg_ref.get_url(None)


    print('Daily Report Generated!')
    
    return url

def monthly_report(info, start, end):
    
    data = info.split('_')

    dept = data[0]
    year = data[1]

    download_csvs(f'Attendance Report/{dept}/{year}/', start, end)

    folder_path = 'csvs/'

    attendance_data = []

    for filename in os.listdir(folder_path):
        if filename.endswith('.csv'):
            date, subject = filename.split('_')[:2]

            if subject.endswith('.csv'):
                subject = subject[0:-4]
            
            with open(os.path.join(folder_path, filename), 'r') as file:
                reader = csv.reader(file)
                headers = next(reader)
                for row in reader:
                    r_no, name, prn, attendance = row
                    attendance_data.append({'date': date, 'subject': subject, 'r_no': r_no, 'name': name, 'prn': prn, 'attendance': int(attendance)})
                    
    attendance_totals = {}

    for record in attendance_data:
        key = (record['r_no'], record['name'], record['prn'])
        if key not in attendance_totals:
            attendance_totals[key] = {}
        attendance_totals[key][record['subject']] = attendance_totals[key].get(record['subject'], {'attendance': 0, 'classes': 0})
        attendance_totals[key][record['subject']]['attendance'] += record['attendance']
        attendance_totals[key][record['subject']]['classes'] += 1

    csv_file = f'attendance_report ({start} to {end}).csv'
    with open(csv_file, 'w', newline='') as file:
        writer = csv.writer(file)
        
        subjects = sorted(list(set([record['subject'] for record in attendance_data])))
        header = ['Roll No', 'Name', 'PRN'] + subjects
        writer.writerow(header)
        
        for key, attendance in attendance_totals.items():
            row = [key[0], key[1], key[2]]
            for subject in subjects:
                if subject in attendance:
                    row.append(round(attendance[subject]['attendance'] / attendance[subject]['classes'] * 100, 2))
                else:
                    row.append('')
            writer.writerow(row)

    
    excel_file = f'{csv_file[0:-4]}.xlsx'
    
    df = pd.read_csv(csv_file)
    df.to_excel(excel_file, index=False)

    stg_ref = storage.child(f"Monthly Reports/{dept}/{year}/{excel_file}")

    stg_ref.put(excel_file)

    os.remove(csv_file)
    os.remove(excel_file)

    storage.path = ''

    url = stg_ref.get_url(None)

    print('Monthly Report Generated!')

    return url
    

while True:

    jobs = database.child("Jobs").child("Reports").get().val()
    for job_id, job_data in jobs.items():
        if job_data.get("remaining") == 'true':
            if job_data.get('type') == 'all':

                info = f"{job_id.split('_')[0]}_{job_id.split('_')[1]}"
                start = format_date(job_data.get('date').split('_')[0])
                end = format_date(job_data.get('date').split('_')[1])

                url = monthly_report(info, start, end)
                if url is None:
                    database.child("Jobs").child("Reports").child(job_id).update({
                        "url": 'None',
                        'remaining' : 'false',
                        'data' : 'false'
                    })
                else:
                    database.child("Jobs").child("Reports").child(job_id).update({
                        "url": url,
                        'remaining' : 'false',
                        'data' : 'true'
                    })
                print(f'Done --> {job_id} --> Monthly')
            else:
                info = f'{job_id}_{format_date(job_data.get("date"))}'

                url = daily_report(info)

                if(url is None):
                    database.child("Jobs").child("Reports").child(job_id).update({
                    "url": 'None',
                    'remaining' : 'false',
                    'data' : 'false'
                    })
                else:
                    database.child("Jobs").child("Reports").child(job_id).update({
                        "url": url,
                        'remaining' : 'false',
                        'data' : 'true'
                    })
                print(f'Done --> {job_id} --> Daily')
    
    time.sleep(1)  