<template>
  <div class="min-h-screen bg-gray-100">
    <header class="bg-white shadow">
      <div class="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
        <h1 class="text-3xl font-bold text-gray-900">Document Template Manager</h1>
      </div>
    </header>

    <div class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
      <div class="bg-white shadow overflow-hidden sm:rounded-lg">
        <div class="px-4 py-5 sm:p-6">
          <section class="mb-8">
            <h2 class="text-2xl font-semibold mb-4">How to Use This Application</h2>
            <p class="text-gray-600 mb-4">
              Follow these steps to manage document templates and generate PDFs:
            </p>
            <ol class="list-decimal list-inside space-y-4">
              <li class="text-gray-700">
                <span class="font-semibold">Define Document Templates:</span> Create templates with unique IDs and test with sample payloads.
              </li>
              <li class="text-gray-700">
                <span class="font-semibold">Use API Endpoints:</span> Integrate services using the provided endpoints. Set the <code class="bg-gray-100 px-1 py-0.5 rounded">X-Access-Key</code> header for authentication.
              </li>
              <li class="text-gray-700">
                <span class="font-semibold">Generate Documents:</span> Use templates to create documents and PDFs (sync or async).
              </li>
              <li class="text-gray-700">
                <span class="font-semibold">Manage Files:</span> Retrieve and manage generated files using document files endpoints.
              </li>
            </ol>
          </section>

          <section class="mb-8">
            <h2 class="text-2xl font-semibold mb-4">API Endpoints</h2>
            <div class="bg-gray-50 rounded-lg p-4">
              <ul class="space-y-2">
                <li v-for="endpoint in endpoints" :key="endpoint.method + endpoint.path">
                  <div class="flex items-center">
                    <span :class="methodClass(endpoint.method)" class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium mr-2">
                      {{ endpoint.method }}
                    </span>
                    <code class="text-sm">{{ endpoint.path }}</code>
                  </div>
                </li>
              </ul>
            </div>
          </section>

          <div class="bg-yellow-50 border-l-4 border-yellow-400 p-4">
            <div class="flex">
              <div class="flex-shrink-0">
                <InformationCircleIcon class="h-5 w-5 text-yellow-400" />
              </div>
              <div class="ml-3">
                <p class="text-sm text-yellow-700">
                  Remember to specify unique IDs for each template and test with sample payloads before integration.
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { InformationCircleIcon } from '@heroicons/vue/24/solid'

export default {
  name: 'HomeScreen',
  components: {
    InformationCircleIcon
  },
  data() {
    return {
      endpoints: [
        { method: 'GET', path: 'api/v1/document-templates' },
        { method: 'GET', path: 'api/v1/document-templates/{uuid}' },
        { method: 'POST', path: 'api/v1/document-templates' },
        { method: 'PUT', path: 'api/v1/document-templates/{uuid}' },
        { method: 'DELETE', path: 'api/v1/document-templates/{uuid}' },
        { method: 'POST', path: 'api/v1/document-templates/{uuid}/pdfs' },
        { method: 'POST', path: 'api/v1/document-templates/{uuid}/pdfs-async' },
        { method: 'GET', path: 'api/v1/document-files' },
        { method: 'POST', path: 'api/v1/document-files/{uuid}' },
      ]
    }
  },
  methods: {
    methodClass(method) {
      const classes = {
        GET: 'bg-green-100 text-green-800',
        POST: 'bg-blue-100 text-blue-800',
        PUT: 'bg-yellow-100 text-yellow-800',
        DELETE: 'bg-red-100 text-red-800'
      }
      return classes[method] || 'bg-gray-100 text-gray-800'
    }
  }
}
</script>