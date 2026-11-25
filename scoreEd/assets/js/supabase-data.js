// ─── Módulo de datos: reemplaza todas las APIs PHP ───

const sbData = {
  // ─── DEPORTES ───
  async getDeportes() {
    const sb = await sbInit()
    const { data } = await sb.from('deportes').select('*').order('id_deporte', { ascending: true })
    return data || []
  },

  // ─── CURSOS ───
  async getCursos() {
    const sb = await sbInit()
    const { data } = await sb.from('cursos').select('*').order('id_curso', { ascending: true })
    return data || []
  },

  // ─── TORNEOS ───
  async getTorneos(idDeporte) {
    const sb = await sbInit()
    let query = sb.from('torneos').select('*')
    if (idDeporte) query = query.eq('id_deporte', parseInt(idDeporte))
    const { data } = await query.order('id_torneo', { ascending: false })
    return data || []
  },

  async createTorneo(body) {
    const sb = await sbInit()
    const { data: maxData } = await sb.from('torneos').select('id_torneo').order('id_torneo', { ascending: false }).limit(1)
    const nextId = (maxData?.[0]?.id_torneo || 0) + 1
    const { data, error } = await sb.from('torneos').insert({ ...body, id_torneo: nextId }).select().single()
    if (error) throw new Error(error.message)
    return data
  },

  async updateTorneo(body) {
    const sb = await sbInit()
    const { id_torneo, ...rest } = body
    const { error } = await sb.from('torneos').update(rest).eq('id_torneo', id_torneo)
    if (error) throw new Error(error.message)
  },

  async deleteTorneo(id) {
    const sb = await sbInit()
    const { error } = await sb.from('torneos').delete().eq('id_torneo', id)
    if (error) throw new Error(error.message)
  },

  // ─── EQUIPOS ───
  async getEquipos(idTorneo) {
    const sb = await sbInit()
    let query = sb.from('equipos').select('id_equipo, nombre, id_torneo, torneos!inner(nombre)')
    if (idTorneo) query = query.eq('id_torneo', parseInt(idTorneo))
    const { data } = await query
    return (data || []).map(e => ({ ...e, torneo: e.torneos?.nombre }))
  },

  async createEquipo(body) {
    const sb = await sbInit()
    const { data: maxData } = await sb.from('equipos').select('id_equipo').order('id_equipo', { ascending: false }).limit(1)
    const nextId = (maxData?.[0]?.id_equipo || 0) + 1
    const { data, error } = await sb.from('equipos').insert({ ...body, id_equipo: nextId }).select().single()
    if (error) throw new Error(error.message)
    return data
  },

  async updateEquipo(body) {
    const sb = await sbInit()
    const { id_equipo, ...rest } = body
    const { error } = await sb.from('equipos').update(rest).eq('id_equipo', id_equipo)
    if (error) throw new Error(error.message)
  },

  async deleteEquipo(id) {
    const sb = await sbInit()
    const { error } = await sb.from('equipos').delete().eq('id_equipo', id)
    if (error) throw new Error(error.message)
  },

  // ─── PARTICIPANTES / JUGADORES ───
  async getJugadores(idDeporte) {
    const sb = await sbInit()
    const { data: torneos } = await sb.from('torneos').select('id_torneo').eq('id_deporte', idDeporte)
    if (!torneos || !torneos.length) return []
    const idsTorneo = torneos.map(t => t.id_torneo)
    const { data: equipos } = await sb.from('equipos').select('id_equipo, nombre').in('id_torneo', idsTorneo)
    if (!equipos || !equipos.length) return []
    const idsEquipo = equipos.map(e => e.id_equipo)
    const equiposMap = {}
    equipos.forEach(e => { equiposMap[e.id_equipo] = e.nombre })

    const { data: all } = await sb.from('participantes').select('*, plantilla!inner(*)').in('plantilla.id_equipo', idsEquipo)
    return (all || []).map(p => {
      const pl = p.plantilla?.[0] || {}
      return {
        ...p, id_equipo: pl.id_equipo, id_curso: pl.id_curso,
        equipo: equiposMap[pl.id_equipo] || '', anio: '', division: pl.id_curso
      }
    })
  },

  async createJugador(body) {
    const sb = await sbInit()
    const { id_equipo, id_curso, ...participante } = body
    const { data: maxP } = await sb.from('participantes').select('id_participante').order('id_participante', { ascending: false }).limit(1)
    const nextP = (maxP?.[0]?.id_participante || 0) + 1
    const { data: p, error: e1 } = await sb.from('participantes').insert({ ...participante, id_participante: nextP }).select().single()
    if (e1) throw new Error(e1.message)
    const { data: maxPl } = await sb.from('plantilla').select('id_plantilla').order('id_plantilla', { ascending: false }).limit(1)
    const nextPl = (maxPl?.[0]?.id_plantilla || 0) + 1
    const { error: e2 } = await sb.from('plantilla').insert({ id_plantilla: nextPl, id_equipo, id_participante: p.id_participante, id_curso }).select()
    if (e2) throw new Error(e2.message)
    return p
  },

  async updateJugador(body) {
    const sb = await sbInit()
    const { id_participante, id_equipo, id_curso, ...rest } = body
    const { error: e1 } = await sb.from('participantes').update(rest).eq('id_participante', id_participante)
    if (e1) throw new Error(e1.message)
    const { error: e2 } = await sb.from('plantilla').update({ id_equipo, id_curso }).eq('id_participante', id_participante)
    if (e2) throw new Error(e2.message)
  },

  async deleteJugador(id) {
    const sb = await sbInit()
    const { error } = await sb.from('participantes').delete().eq('id_participante', id)
    if (error) throw new Error(error.message)
  },

  // ─── ÁRBITROS ───
  async getArbitros() {
    const sb = await sbInit()
    const { data } = await sb.from('profiles').select('id, email, nombre, id_arbitro_ref').eq('rol', 'arbitro')
    return (data || []).map(a => ({ id_arbitro: a.id_arbitro_ref, nombre: a.nombre, email: a.email, id_uuid: a.id }))
  },

  // ─── PARTIDOS ───
  async getPartidos() {
    const sb = await sbInit()
    const { data } = await sb.from('partidos').select('*, equipos_local:equipos!partidos_id_equipo_local_fkey!inner(nombre), equipos_visitante:equipos!partidos_id_equipo_visitante_fkey!inner(nombre), torneos!partidos_id_torneo_fkey!inner(nombre), estados!partidos_id_estado_fkey!inner(nombre)')
    const { data: arbitros } = await sb.from('profiles').select('id_arbitro_ref, nombre').eq('rol', 'arbitro')
    const arbMap = {}
    if (arbitros) arbitros.forEach(a => { if (a.id_arbitro_ref) arbMap[a.id_arbitro_ref] = a.nombre })
    return (data || []).map(p => ({
      ...p,
      equipo_local: p.equipos_local?.nombre,
      equipo_visitante: p.equipos_visitante?.nombre,
      torneo: p.torneos?.nombre,
      arbitro: arbMap[p.id_arbitro] || null,
      estado: p.estados?.nombre
    }))
  },

  async getPartidosArbitro() {
    const s = await sbSession()
    if (!s) return []
    const sb = await sbInit()
    const { data } = await sb.from('partidos').select('*, equipos_local:equipos!partidos_id_equipo_local_fkey!inner(nombre), equipos_visitante:equipos!partidos_id_equipo_visitante_fkey!inner(nombre), torneos!partidos_id_torneo_fkey!inner(nombre, id_deporte), estados!partidos_id_estado_fkey!inner(nombre)')
      .eq('id_arbitro', s.profile.id_arbitro_ref)
      .order('fecha', { ascending: true })
    return (data || []).map(p => ({
      ...p,
      equipo_local: p.equipos_local?.nombre,
      equipo_visitante: p.equipos_visitante?.nombre,
      torneo: p.torneos?.nombre,
      id_deporte: p.torneos?.id_deporte,
      estado: p.estados?.nombre
    }))
  },

  async getPartidoDetalle(idPartido) {
    const sb = await sbInit()
    const { data: partido } = await sb.from('partidos').select('*, equipos_local:equipos!partidos_id_equipo_local_fkey!inner(nombre), equipos_visitante:equipos!partidos_id_equipo_visitante_fkey!inner(nombre), torneos!partidos_id_torneo_fkey!inner(nombre, id_deporte), estados!partidos_id_estado_fkey!inner(nombre)')
      .eq('id_partido', idPartido).single()
    const { data: eventos } = await sb.from('eventos_partido').select('*, participantes!inner(nombre, apellido), tipos_evento!inner(nombre, afecta_marcador, valor)')
      .eq('id_partido', idPartido).order('minuto', { ascending: true })
    const { data: plantillaLocal } = await sb.from('plantilla').select('participantes!inner(id_participante, nombre, apellido)')
      .eq('id_equipo', partido?.id_equipo_local)
    const { data: plantillaVisit } = await sb.from('plantilla').select('participantes!inner(id_participante, nombre, apellido)')
      .eq('id_equipo', partido?.id_equipo_visitante)
    const { data: arbitros } = await sb.from('profiles').select('id_arbitro_ref, nombre').eq('rol', 'arbitro')
    const arbMap = {}
    if (arbitros) arbitros.forEach(a => { if (a.id_arbitro_ref) arbMap[a.id_arbitro_ref] = a.nombre })

    const localIds = new Set((plantillaLocal || []).map(pl => pl.participantes?.id_participante))

    return {
      partido: {
        ...partido,
        equipo_local: partido?.equipos_local?.nombre,
        equipo_visitante: partido?.equipos_visitante?.nombre,
        torneo: partido?.torneos?.nombre,
        id_deporte: partido?.torneos?.id_deporte,
        estado: partido?.estados?.nombre,
        arbitro: arbMap[partido?.id_arbitro] || null
      },
      eventos: (eventos || []).map(e => ({
        ...e,
        nombre: e.participantes?.nombre,
        apellido: e.participantes?.apellido,
        tipo: e.tipos_evento?.nombre,
        equipo_rol: e.equipo_rol || (localIds.has(e.id_participante) ? 'local' : 'visitante')
      })),
      plantilla_local: (plantillaLocal || []).map(pl => pl.participantes),
      plantilla_visitante: (plantillaVisit || []).map(pl => pl.participantes)
    }
  },

  async createPartido(body) {
    const sb = await sbInit()
    const { data: maxData } = await sb.from('partidos').select('id_partido').order('id_partido', { ascending: false }).limit(1)
    const nextId = (maxData?.[0]?.id_partido || 0) + 1
    const { data, error } = await sb.from('partidos').insert({ ...body, id_partido: nextId, id_estado: 1 }).select().single()
    if (error) throw new Error(error.message)
    return data
  },

  async updatePartido(body) {
    const sb = await sbInit()
    const { id_partido, ...rest } = body
    const { error } = await sb.from('partidos').update(rest).eq('id_partido', id_partido)
    if (error) throw new Error(error.message)
  },

  async deletePartido(id) {
    const sb = await sbInit()
    const { error } = await sb.from('partidos').delete().eq('id_partido', id)
    if (error) throw new Error(error.message)
  },

  async updateEstadoPartido(idPartido, idEstado) {
    const sb = await sbInit()
    const { error } = await sb.from('partidos').update({ id_estado: idEstado }).eq('id_partido', idPartido)
    if (error) throw new Error(error.message)
  },

  // ─── ACTUALIZAR MARCADOR ───
  async actualizarMarcador(idPartido) {
    const sb = await sbInit()
    const [eventosRes, partidoRes] = await Promise.all([
      sb.from('eventos_partido').select('*, tipos_evento!inner(afecta_marcador, valor, id_deporte)').eq('id_partido', idPartido),
      sb.from('partidos').select('id_equipo_local, id_equipo_visitante').eq('id_partido', idPartido).single()
    ])
    const eventos = eventosRes.data
    const partido = partidoRes.data
    if (!eventos || !partido) return

    const { data: plLocal } = await sb.from('plantilla').select('id_participante').eq('id_equipo', partido.id_equipo_local)
    const { data: plVisit } = await sb.from('plantilla').select('id_participante').eq('id_equipo', partido.id_equipo_visitante)
    const localIds = new Set((plLocal || []).map(p => p.id_participante))
    const visitIds = new Set((plVisit || []).map(p => p.id_participante))

    let local = 0, visit = 0
    for (const e of eventos) {
      if (!e.tipos_evento?.afecta_marcador) continue
      const valor = e.tipos_evento.valor || 1
      const rol = e.equipo_rol || (localIds.has(e.id_participante) ? 'local' : 'visitante')
      if (rol === 'local') local += valor
      else visit += valor
    }

    const { error } = await sb.from('partidos').update({ marcador_local: local, marcador_visitante: visit }).eq('id_partido', idPartido)
    if (error) console.warn('actualizarMarcador error:', error.message)
  },

  // ─── EVENTOS ───
  async createEvento(body) {
    const sb = await sbInit()
    const { data: maxData } = await sb.from('eventos_partido').select('id_evento').order('id_evento', { ascending: false }).limit(1)
    const nextId = (maxData?.[0]?.id_evento || 0) + 1
    const { data, error } = await sb.from('eventos_partido').insert({ ...body, id_evento: nextId, comentarios: body.comentarios ?? '' }).select().single()
    if (error) throw new Error(error.message)
    await sbData.actualizarMarcador(body.id_partido)
    return data
  },

  async deleteEvento(id) {
    const sb = await sbInit()
    const { data: ev } = await sb.from('eventos_partido').select('id_partido').eq('id_evento', id).single()
    if (!ev) return
    const { data, error } = await sb.from('eventos_partido').delete().eq('id_evento', id).select()
    if (error) throw new Error(error.message)
    if (!data || data.length === 0) throw new Error('No se pudo eliminar el evento (sin permisos o no existe)')
    await sbData.actualizarMarcador(ev.id_partido)
  },

  async getTiposEvento(idTorneo) {
    const sb = await sbInit()
    let query = sb.from('tipos_evento').select('*')
    if (idTorneo) {
      const { data: torneo } = await sb.from('torneos').select('id_deporte').eq('id_torneo', idTorneo).single()
      if (torneo) query = query.eq('id_deporte', torneo.id_deporte)
    }
    const { data } = await query.order('id_tipo_evento', { ascending: true })
    return data || []
  },

  async getParticipantes(idEquipo) {
    const sb = await sbInit()
    const { data } = await sb.from('plantilla').select('participantes!inner(id_participante, nombre, apellido)').eq('id_equipo', idEquipo)
    return (data || []).map(pl => pl.participantes)
  },

  // ─── ESTADÍSTICAS ───
  async getProximos(idTorneo, idDeporte) {
    const sb = await sbInit()
    let query = sb.from('partidos').select('*, equipos_local:equipos!partidos_id_equipo_local_fkey!inner(nombre), equipos_visitante:equipos!partidos_id_equipo_visitante_fkey!inner(nombre), torneos!partidos_id_torneo_fkey!inner(nombre)').eq('id_estado', 1)
    if (idTorneo) query = query.eq('id_torneo', idTorneo)
    if (idDeporte) query = query.eq('torneos.id_deporte', idDeporte)
    const { data } = await query.order('fecha', { ascending: true })
    return (data || []).map(p => ({
      ...p, equipo_local: p.equipos_local?.nombre, equipo_visitante: p.equipos_visitante?.nombre, torneo: p.torneos?.nombre
    }))
  },

  async getResultados(idTorneo, idDeporte) {
    const sb = await sbInit()
    let query = sb.from('partidos').select('*, equipos_local:equipos!partidos_id_equipo_local_fkey!inner(nombre), equipos_visitante:equipos!partidos_id_equipo_visitante_fkey!inner(nombre), torneos!partidos_id_torneo_fkey!inner(nombre), estados!partidos_id_estado_fkey!inner(nombre)').in('id_estado', [2, 3])
    if (idTorneo) query = query.eq('id_torneo', idTorneo)
    if (idDeporte) query = query.eq('torneos.id_deporte', idDeporte)
    const { data } = await query.order('fecha', { ascending: false })
    return (data || []).map(p => ({
      ...p, equipo_local: p.equipos_local?.nombre, equipo_visitante: p.equipos_visitante?.nombre, torneo: p.torneos?.nombre, estado: p.estados?.nombre
    }))
  },

  // ─── TABLA DE POSICIONES ───
  async getTablaPosiciones(idTorneo) {
    const sb = await sbInit()
    const { data: partidos } = await sb.from('partidos').select('id_equipo_local, id_equipo_visitante, marcador_local, marcador_visitante')
      .eq('id_torneo', idTorneo).eq('id_estado', 3)
    const { data: reglas } = await sb.from('reglas_puntos').select('*')
      .eq('id_deporte', (await sb.from('torneos').select('id_deporte').eq('id_torneo', idTorneo).single()).data?.id_deporte)

    const pts = { victoria: 3, empate: 1, derrota: 0 }
    if (reglas) reglas.forEach(r => { pts[r.resultado] = r.puntos })

    const tabla = {}
    const addEq = (id, mf, mc) => {
      if (!tabla[id]) tabla[id] = { id_equipo: id, pj: 0, pg: 0, pe: 0, pp: 0, gf: 0, gc: 0, dg: 0, pts: 0 }
      const t = tabla[id]
      t.pj++; t.gf += mf; t.gc += mc
      if (mf > mc) { t.pg++; t.pts += pts.victoria }
      else if (mf === mc && pts.empate !== undefined) { t.pe++; t.pts += pts.empate }
      else { t.pp++; t.pts += pts.derrota }
    }
    if (partidos) partidos.forEach(p => {
      addEq(p.id_equipo_local, p.marcador_local || 0, p.marcador_visitante || 0)
      addEq(p.id_equipo_visitante, p.marcador_visitante || 0, p.marcador_local || 0)
    })

    const ids = Object.keys(tabla)
    if (ids.length) {
      const { data: equipos } = await sb.from('equipos').select('id_equipo, nombre').in('id_equipo', ids.map(Number))
      if (equipos) equipos.forEach(e => {
        if (tabla[e.id_equipo]) tabla[e.id_equipo].equipo = e.nombre
      })
    }
    return Object.values(tabla).sort((a, b) => b.pts - a.pts || (b.gf - b.gc) - (a.gf - a.gc))
  },

  // ─── FIXTURE ───
  async crearFixture(partidos) {
    const sb = await sbInit()
    const { data: maxData } = await sb.from('partidos').select('id_partido').order('id_partido', { ascending: false }).limit(1)
    let nextId = (maxData?.[0]?.id_partido || 0) + 1
    const inserts = partidos.map(p => ({ ...p, id_partido: nextId++, id_estado: 1 }))
    const { error } = await sb.from('partidos').insert(inserts)
    if (error) throw new Error(error.message)
  },

  // ─── ESTADÍSTICAS ───
  async getEstadisticas(idTorneo) {
    const sb = await sbInit()
    const { data: partidos } = await sb.from('partidos').select('id_partido').eq('id_torneo', idTorneo).in('id_estado', [2, 3])
    if (!partidos || !partidos.length) return { goleadores: [], tarjetas_amarillas: [], tarjetas_rojas: [] }
    const idsPartidos = partidos.map(p => p.id_partido)

    const [eventosData, tiposData, partData, equiposData] = await Promise.all([
      sb.from('eventos_partido').select('id_participante, id_tipo_evento, minuto').in('id_partido', idsPartidos),
      sb.from('tipos_evento').select('id_tipo_evento, nombre, afecta_marcador'),
      sb.from('participantes').select('id_participante, nombre, apellido'),
      sb.from('plantilla').select('id_participante, equipos!plantilla_id_equipo_fkey!inner(nombre)')
    ])
    const tiposMap = {}
    if (tiposData.data) tiposData.data.forEach(t => { tiposMap[t.id_tipo_evento] = t })
    const partsMap = {}
    if (partData.data) partData.data.forEach(p => { partsMap[p.id_participante] = p })
    const eqMap = {}
    if (equiposData.data) equiposData.data.forEach(p => { eqMap[p.id_participante] = p.equipos?.nombre })

    const goles = {}
    const amarillas = {}
    const rojas = {}
    if (eventosData.data) eventosData.data.forEach(e => {
      const nombre = partsMap[e.id_participante]
        ? `${partsMap[e.id_participante].nombre} ${partsMap[e.id_participante].apellido}`
        : 'Desconocido'
      const equipo = eqMap[e.id_participante] || ''
      const tipo = tiposMap[e.id_tipo_evento]
      if (!tipo) return
      const t = tipo.nombre.toLowerCase()
      if (tipo.afecta_marcador || t.includes('gol')) {
        if (!goles[e.id_participante]) goles[e.id_participante] = { jugador: nombre, equipo, total: 0 }
        goles[e.id_participante].total++
      }
      if (t.includes('amarilla')) {
        if (!amarillas[e.id_participante]) amarillas[e.id_participante] = { jugador: nombre, tarjetas: 0 }
        amarillas[e.id_participante].tarjetas++
      }
      if (t.includes('roja')) {
        if (!rojas[e.id_participante]) rojas[e.id_participante] = { jugador: nombre, tarjetas: 0 }
        rojas[e.id_participante].tarjetas++
      }
    })

    return {
      goleadores: Object.values(goles).sort((a, b) => b.total - a.total).slice(0, 10),
      tarjetas_amarillas: Object.values(amarillas).sort((a, b) => b.tarjetas - a.tarjetas).slice(0, 10),
      tarjetas_rojas: Object.values(rojas).sort((a, b) => b.tarjetas - a.tarjetas).slice(0, 10)
    }
  }
}
