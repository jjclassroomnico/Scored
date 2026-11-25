var SUPABASE_URL = 'https://oqyrtgplauttdkzcdtnf.supabase.co'
var SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9xeXJ0Z3BsYXV0dGRremNkdG5mIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODM1MTIzMTYsImV4cCI6MjA5OTA4ODMxNn0.tikMkpQpS3BSe4e_bX8LUN4t4lwG8phxGW2NB9UKbS0'

async function sbInit() {
  if (window.__sb) return window.__sb
  return new Promise(function(resolve) {
    function check() {
      if (window.supabase && window.supabase.createClient) {
        window.__sb = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
          auth: { autoRefreshToken: true, persistSession: true, detectSessionInUrl: false },
          global: { headers: { 'X-Client-Info': 'supabase-js-web' } }
        })
        resolve(window.__sb)
      } else setTimeout(check, 100)
    }
    check()
  })
}

async function sbLogin(email, password, rolEsperado) {
  var sb = await sbInit()
  var result = await sb.auth.signInWithPassword({ email: email, password: password })
  if (result.error) throw new Error(result.error.message)
  var user = result.data.user
  var profileRes = await sb.from('profiles').select('rol').eq('id', user.id).single()
  if (profileRes.error) throw new Error(profileRes.error.message)
  if (!profileRes.data || profileRes.data.rol !== rolEsperado) {
    await sb.auth.signOut()
    throw new Error('Acceso denegado: No tienes rol de ' + rolEsperado)
  }
  return { user: user, profile: profileRes.data }
}

async function sbLogout() {
  var sb = await sbInit()
  await sb.auth.signOut()
}

async function sbSession() {
  var sb = await sbInit()
  var result = await sb.auth.getSession()
  if (!result.data || !result.data.session) return null
  var profileRes = await sb.from('profiles').select('*').eq('id', result.data.session.user.id).single()
  if (profileRes.error) return null
  return { session: result.data.session, profile: profileRes.data }
}

async function sbRequireAuth(rolEsperado) {
  var s = await sbSession()
  if (!s || s.profile.rol !== rolEsperado) {
    window.location.href = (rolEsperado === 'admin' ? '/scoreEd/views/admin/login.html' : '/scoreEd/views/arbitro/login.html')
    return null
  }
  return s
}

async function sbCheckLoginPage(rolEsperado) {
  var s = await sbSession()
  if (s) {
    if (s.profile.rol === rolEsperado) {
      window.location.href = (rolEsperado === 'admin' ? '/scoreEd/views/admin/dashboard.html' : '/scoreEd/views/arbitro/panel.html')
    } else {
      await sbLogout()
    }
  }
}
