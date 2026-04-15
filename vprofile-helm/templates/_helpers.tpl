{{/*
Expand the name of the chart.
*/}}
{{- define "vprofile-helm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "vprofile-helm.fullname" -}}
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
{{- define "vprofile-helm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "vprofile-helm.labels" -}}
helm.sh/chart: {{ include "vprofile-helm.chart" . }}
{{ include "vprofile-helm.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "vprofile-helm.selectorLabels" -}}
app.kubernetes.io/name: {{ include "vprofile-helm.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "vprofile-helm.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "vprofile-helm.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Define functions to pass image
*/}}
{{- define "app.image" -}}
{{- if .Values.registry }}
{{- .Values.registry | trimSuffix "/"}}{{ "/" }}
{{- end }}
{{- .Values.app.image.repository }}{{ ":" }}
{{- with .Values.app }}
{{- .image.tag | default "latest" }}
{{- else }}
{{- "latest" }}
{{- end }}
{{- end }}

{{- define "cache.image" -}}
{{- .Values.cache.image.repository }}{{ ":" }}
{{- with .Values.cache }}
{{- .image.tag | default "latest" }}
{{- else }}
{{- "latest" }}
{{- end }}
{{- end }}
