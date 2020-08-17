# WDTS

Windows Deployment Tools System

General Goals:

- Scripts files to configure the deployment features.

- Pluggable architecture

- DataBase model to register the configuration, permissions, versions, logging tracking , log errors, at son on.
Web-based dashboard to configure the permissions, the schedules, run the deployment script on demand, view reports at son on.
- Expose Rest Services to expose configuration backend to fronts end (created or not in .net technologies)

- Use framework logging (to define) to log the audits events, error, and information messages.

- The types of script couldn't depend the this architecture, can be python , PowebShel, Perl or other type of script. In the deployment time, using custom configuration the system must be adapted to this scripts technologies.

