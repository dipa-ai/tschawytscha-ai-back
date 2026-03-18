{{- define "tshawytscha.name" -}}
{{- .Values.name | default .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "tshawytscha.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/name: {{ include "tshawytscha.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app: {{ .Values.name }}
{{- end }}

{{- define "tshawytscha.selectorLabels" -}}
app: {{ .Values.name }}
{{- end }}
