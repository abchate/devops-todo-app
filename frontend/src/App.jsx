import { useState, useEffect } from 'react'
import axios from 'axios'
import './App.css'

function App() {
  const [message, setMessage] = useState('Loading...')
  const [error, setError] = useState(null)
  
  useEffect(() => {
    const fetchData = async () => {
      try {
        // In development with Vite, the proxy will handle this
        // In production with Docker, we'll use the BACKEND_URL env variable
        const baseUrl = import.meta.env.VITE_BACKEND_URL || '/api'
        const response = await axios.get(`${baseUrl}/hello`)
        setMessage(response.data.message)
      } catch (err) {
        console.error('Error fetching data:', err)
        setError('Failed to fetch data from the API')
        setMessage('')
      }
    }

    fetchData()
  }, [])

  return (
    <div className="app">
      <header className="app-header">
        <h1>DevOps Todo App</h1>
        
        <div className="team-banner">
          <h2>👋 Salut Fatou, Ishrat, Kewe, Ilyess!</h2>
          <p className="team-message">
            C'est notre projet DevOps - on mérite clairement un 20/20! 🚀😎
          </p>
        </div>
        
        <div className="card">
          <h2>Message from API:</h2>
          {error ? (
            <p className="error">{error}</p>
          ) : (
            <p className="message">{message}</p>
          )}
        </div>
        
        <div className="fun-container">
          <p className="joke">Comment on sait qu'un développeur a implémenté Docker?</p>
          <p className="punchline">Il dit "ça marche sur mon container" au lieu de "ça marche sur ma machine"! 🐳</p>
        </div>
        
        <p className="description">
          Full-stack boilerplate with React + Express + Docker
        </p>
      </header>
    </div>
  )
}

export default App
