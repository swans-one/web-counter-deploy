import { error } from "@sveltejs/kit";

const apiRoot = "http://localhost:8000"

export async function load() {
  const apiResponse = await fetch(apiRoot + "/increment", { method: "GET" })

  if (!apiResponse.ok) {
    error(500, "Could not connect to API server")
  }

  return {
    apiResponse: await apiResponse.json(),
  };
}
