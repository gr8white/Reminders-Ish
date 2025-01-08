#  Syncing with iCloud

- Navigate to project file, select "Signing & Capabilities"
- Add new capability ("+ Capability")
- Select iCloud option
- Select CloudKit option under services
- Select or add new container using project bundle id
- Add new capability, select Background Modes option
- Select "Remote notifications" from Options list
- Click "CloudKit Console" under iCloud capability


CloudKit Console
- Select CloudKit Database
- Make sure correct application is selected
- Choose public, private, or shared database (SwiftData only works with private)
