from django.contrib import admin

from .models import User,Project,EmployeeProject,Profile,ProjectAssignment

# Register your models here.
admin.site.register(User)
admin.site.register(Project)
admin.site.register(EmployeeProject)
admin.site.register(Profile)
admin.site.register(ProjectAssignment)