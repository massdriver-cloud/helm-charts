{{/*
Since this is a generic chart, Release is the only field relevant to naming
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "scheduled-job.fullname" -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "scheduled-job.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "scheduled-job.labels" -}}
{{ include "scheduled-job.selectorLabels" . }}
{{- with .Values.labels }}
{{ toYaml . }}
{{- end }}
app.kubernetes.io/managed-by: massdriver.cloud
{{- end }}

{{/*
Selector labels
*/}}
{{- define "scheduled-job.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
{{- end }}