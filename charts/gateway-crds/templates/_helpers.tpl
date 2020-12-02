{{/*
Common labels
*/}}
{{- define "gateway-crds.labels" -}}
app.kubernetes.io/name: gateway-crds
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
