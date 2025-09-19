from rest_framework import generics
from .models import Project
from .serializers import ProjectSerializer

class ProjectCreateView(generics.ListCreateAPIView):
    queryset = Project.objects.all()
    serializer_class = ProjectSerializer

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)   # validate input
        if serializer.is_valid():
            serializer.save(lead=request.user)   # save with logged-in user as lead
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class ProjectCreateView(generics.ListCreateAPIView):
    queryset = Project.objects.all()
    serializer_class = ProjectSerializer

    def perform_create(self, serializer):
        serializer.save(lead=self.request.user)  # 👈 lead is auto set

