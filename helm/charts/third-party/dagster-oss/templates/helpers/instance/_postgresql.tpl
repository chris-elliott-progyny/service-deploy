{{- define "dagsterYaml.postgresql.config" }}
postgres_db:
  username:
    env: DAGSTER_PG_USERNAME
  password:
    env: DAGSTER_PG_PASSWORD
  hostname:
    env: DAGSTER_PG_HOSTNAME
  db_name: 
    env: DAGSTER_PG_DB_NAME
  port:
    env: DAGSTER_PG_PORT
  params: {{- .Values.postgresql.postgresqlParams | toYaml | nindent 4 }}
  {{- if .Values.postgresql.postgresqlScheme }}
  scheme: {{ .Values.postgresql.postgresqlScheme }}
  {{- end }}
{{- end }}
