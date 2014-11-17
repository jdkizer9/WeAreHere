from django.conf.urls import patterns, include, url
from django.contrib import admin
from testLog import testLog

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'wah_backend.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),

    url(r'^admin/', include(admin.site.urls)),
    url(r'^testLog/', include(testLog))
)