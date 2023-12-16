import os
import subprocess

report = "attendanceReport.py"
attendance = "takeAttendance.py"

python_files = [report, attendance]

for file in python_files:

    command = f'start cmd.exe /k "python {file}"'

    try:
        subprocess.run(command, shell=True)
    except FileNotFoundError:
        print(f"Error: file {file} not found.")
