# Base image
FROM python:3.9

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set work directory
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

RUN addgroup --system app \
    && adduser --system --ingroup app app


RUN mkdir /app/static
RUN chmod 755 /app/static

# Copy project files
COPY ./app .
COPY scripts/entrypoint.sh .

RUN chmod +x /app/entrypoint.sh

# Collect static files
# RUN python manage.py collectstatic --no-input

# Run migrations
# RUN python manage.py migrate
RUN chown -R app:app /app

USER app

# Expose port for Gunicorn
EXPOSE 8000

ENTRYPOINT ["/app/entrypoint.sh"]

# Start Gunicorn
# CMD ["gunicorn", "--bind", "0.0.0.0:8000", "my_fight.wsgi.application"]
