{{/*
Expand the name of the chart.
*/}}
{{- define "massdriver.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "massdriver.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "massdriver.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "massdriver.labels" -}}
helm.sh/chart: {{ include "massdriver.chart" . }}
{{ include "massdriver.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "massdriver.selectorLabels" -}}
app.kubernetes.io/name: {{ include "massdriver.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
TLS Secret Name
*/}}
{{- define "massdriver.tlsSecretName" -}}
  {{- $default := printf "%s-massdriver-tls" (include "massdriver.fullname" .) -}}
  {{- default $default .Values.massdriver.ingress.tls.secretName -}}
{{- end }}

{{/*
Protocol to use for links (http or https)
*/}}
{{- define "massdriver.protocol" -}}
  {{- if .Values.massdriver.ingress.tls.enabled }}
  {{- printf "https" }}
  {{- else }}
  {{- printf "http" }}
  {{- end }}
{{- end }}

{{/*
Websocket protocol to use (ws or wss)
*/}}
{{- define "massdriver.websocketProtocol" -}}
  {{- if .Values.massdriver.ingress.tls.enabled }}
  {{- printf "wss" }}
  {{- else }}
  {{- printf "ws" }}
  {{- end }}
{{- end }}

{{/*
Returns the available value for certain key in an existing secret (if it exists),
otherwise it generates a random value.
*/}}
{{- define "massdriver.getValueFromSecret" }}
  {{- $len := (default 16 .Length) | int -}}
  {{- $secret := (lookup "v1" "Secret" .Namespace .Name).data -}}
  {{- if and $secret (hasKey $secret .Key) }}
    {{- index $secret .Key | b64dec -}}
  {{- else -}}
    {{- randAlphaNum $len -}}
  {{- end -}}
{{- end }}

{{/*
Cloak Key has it's own function because it is base64 encoded itself, 
so we have to handle the "double" base64 encoding gracefully
*/}}
{{- define "massdriver.cloakKey" }}
  {{- $secretName := printf "%s-massdriver-envs" (include "massdriver.fullname" .) -}}
  {{- $secret := (lookup "v1" "Secret" .Release.Namespace $secretName).data -}}
  {{- if and $secret (hasKey $secret "MD_CLOAK_KEY") }}
    {{- index $secret "MD_CLOAK_KEY" | b64dec -}}
  {{- else -}}
    {{- randAlphaNum 32 | b64enc -}}
  {{- end -}}
{{- end }}

{{- define "massdriver.graphqlSubscriptionSecretKey" -}}
  {{- include "massdriver.getValueFromSecret" (dict "Namespace" .Release.Namespace "Name" (printf "%s-massdriver-envs" (include "massdriver.fullname" .)) "Length" 64 "Key" "MD_GRAPHQL_SUBSCRIPTION_SECRET_KEY") }}
{{- end -}}

{{- define "massdriver.jwtSecret" -}}
  {{- include "massdriver.getValueFromSecret" (dict "Namespace" .Release.Namespace "Name" (printf "%s-massdriver-envs" (include "massdriver.fullname" .)) "Length" 64 "Key" "JWT_SECRET") }}
{{- end -}}

{{- define "massdriver.releaseCookie" -}}
  {{- include "massdriver.getValueFromSecret" (dict "Namespace" .Release.Namespace "Name" (printf "%s-massdriver-envs" (include "massdriver.fullname" .)) "Length" 64 "Key" "RELEASE_COOKIE") }}
{{- end -}}

{{- define "massdriver.phxSecretKeyBase" -}}
  {{- include "massdriver.getValueFromSecret" (dict "Namespace" .Release.Namespace "Name" (printf "%s-massdriver-envs" (include "massdriver.fullname" .)) "Length" 64 "Key" "PHX_SECRET_KEY_BASE") }}
{{- end -}}

{{- define "massdriver.phxSigningSalt" -}}
  {{- include "massdriver.getValueFromSecret" (dict "Namespace" .Release.Namespace "Name" (printf "%s-massdriver-envs" (include "massdriver.fullname" .)) "Length" 20 "Key" "PHX_SIGNING_SALT") }}
{{- end -}}