from django.db import models

# Create your models here.
class Fruit(models.Model):
    name = models.CharField(max_length=30)
    color = models.CharField(max_length=30)
    price = models.CharField(max_length=10)
