# HackAthlone Backend

This repository contains the backend API services for the HackAthlone project, built using [Supabase](https://supabase.com/), an open-source Firebase alternative.

## Project Overview

The `hackathlone-backend` provides API services to support the HackAthlone application, leveraging Supabase for database management, authentication, and real-time features.

## Supabase Project Credentials

- **Project URL**: `https://iabynsixhpfbceluzvvs.supabase.co`
- **API Key (Anon)**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlhYnluc2l4aHBmYmNlbHV6dnZzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg0NjMyNjcsImV4cCI6MjA2NDAzOTI2N30.B-QmCrN6VHEfeFZc9kZfGYDoOwtcLimUGzqVgLa4Vis`

> **⚠️ Warning**: Keep the API keys secure and avoid exposing sensitive keys. The provided key is the public `anon` key, safe for client-side use.

## Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) (v16 or higher)
- [Supabase CLI](https://supabase.com/docs/guides/cli) (Install with `npm install -g @supabase/supabase-cli`)
- If you are running Supabase locally, see the [Supabase Container tool](https://supabase.com/docs/guides/local-development/cli/getting-started?queryGroups=platform&platform=npm&queryGroups=access-method&access-method=studio#running-supabase-locally)for Docker config or alternative tools.

### Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/iecloudbird/hackathlone-backend.git
   cd hackathlone-backend
   ```

2. Install Dependencies

   ```bash
    npm install
   ```

3. Link to Supabase Project

```bash
supabase link --project-ref iabynsixhpfbceluzvvs
```

4. Pull remote schema

```bash
supabase db pull
```
Pulling data? 
```bash
supabase db dump --data-only
```


> [!IMPORTANT]
> Database password will be prompted after below step, reach out to project owner for secret acess

If not already logged in, authenticate with the Supabase CLI:

```bash
supabase login
```

4. Start the Supabase Local Development Environment (Docker configs needed)
   To use Supabase's local development features, start the local Supabase instance:

```bash
supabase start
```

## Refer to [Supabase docs](https://supabase.com/docs) for working with:

- Database queries
- Auth sessions
- Real-time subscriptions
