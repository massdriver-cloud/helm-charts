{{/*
Since this is a template chart, the chart name will be filled in by the user and is the primary naming field.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "adhoc-job.fullname" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "adhoc-job.timestamp" -}}
{{ now | date "20060102150405" }}
{{- end }}

{{- define "adhoc-job.timestamped-name" -}}
{{- printf "%s-%s" .Chart.Name (include "adhoc-job.timestamp" . ) | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "adhoc-job.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "adhoc-job.labels" -}}
{{ include "adhoc-job.selectorLabels" . }}
{{- with .Values.labels }}
{{ toYaml . }}
{{- end }}
app.kubernetes.io/managed-by: massdriver.cloud
{{- end }}

{{/*
Selector labels
*/}}
{{- define "adhoc-job.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
{{- end }}