import type { FetchScrapboxProjectTitles } from '@repo/workflow'
import { ResultAsync } from 'neverthrow'
import { scrapboxApiUrl } from './helper/index.js'

type ProjectTitlesResponse = {
  id: string
  title: string
  links: string[]
  image?: string
  updated: number
}[]

export function setupFetchProjectTitles(
  sid?: string,
): FetchScrapboxProjectTitles {
  return (projectName: string) =>
    ResultAsync.fromPromise(
      fetch(`${scrapboxApiUrl}/pages/${projectName}/search/titles`, {
        headers: {
          ...(sid ? { Cookie: `connect.sid=${sid}` } : {}),
        },
      })
        .then(async response => await response.json() as ProjectTitlesResponse),
      (error) => {
        if (error instanceof Error) {
          return error
        }
        return new Error('Unknown error occurred while fetching project titles')
      },
    )
}
