# Stage 3 Runbook

Configure Nginx reverse proxy so the app loads without :3000

## Goal of Stage 3

By the end of Stage 3, the user should be able to visit:
	•	http://APP_PUBLIC_IP/

And see the Sparta app, not the default Nginx page.

This means:

	• Nginx runs on port 80

	• Node app runs on port 3000

	• Nginx forwards requests from 80 → 3000

### What I added into each of the playbooks to get reverse proxy working

```
    - name: Configure Nginx reverse proxy to port 3000
      ansible.builtin.copy:
        dest: /etc/nginx/sites-available/default
        content: |
          server {
              listen 80 default_server;
              listen [::]:80 default_server;

              location / {
                  proxy_pass http://127.0.0.1:3000;
                  proxy_http_version 1.1;
                  proxy_set_header Upgrade $http_upgrade;
                  proxy_set_header Connection "upgrade";
                  proxy_set_header Host $host;
                  proxy_cache_bypass $http_upgrade;
              }
          }
      notify: Restart nginx

    - name: Ensure nginx is enabled
      ansible.builtin.systemd:
        name: nginx
        enabled: true
        state: started
```

Instead of restarting nginx every time:

	• Nginx restarts only when the config changes

	• Makes playbook cleaner and idempotent


## What Stage 3 completed for us

After Stage 3:

✅ App works on port 80
✅ No need to expose :3000 publicly
✅ Nginx behaves like a real web gateway
✅ Ready to connect DB properly next