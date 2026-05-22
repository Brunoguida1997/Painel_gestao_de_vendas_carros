<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>CarGood — Dashboard de Vendas</title>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.js"></script>
<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
  :root {
    --bg: #f5f5f3; --surface: #ffffff; --surface2: #f0efe9;
    --text: #1a1a18; --muted: #6b6b66; --border: rgba(0,0,0,0.12);
    --green: #1D9E75; --blue: #185FA5; --coral: #D85A30;
    --amber: #BA7517; --purple: #534AB7; --green-bg: #E1F5EE;
    --blue-bg: #E6F1FB; --amber-bg: #FAEEDA;
  }
  @media (prefers-color-scheme: dark) {
    :root {
      --bg: #1a1a18; --surface: #242422; --surface2: #2e2e2b;
      --text: #f0efe9; --muted: #9a9992; --border: rgba(255,255,255,0.1);
      --green-bg: #04342C; --blue-bg: #042C53; --amber-bg: #412402;
    }
  }
  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; background: var(--bg); color: var(--text); padding: 2rem; }
  header { display: flex; align-items: baseline; gap: 12px; margin-bottom: 2rem; }
  .logo { font-size: 26px; font-weight: 600; letter-spacing: -0.5px; }
  .logo span { color: var(--green); }
  .sub { font-size: 14px; color: var(--muted); }
  .kpi-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(160px, 1fr)); gap: 12px; margin-bottom: 1.5rem; }
  .kpi { background: var(--surface2); border-radius: 10px; padding: 1.1rem 1.25rem; }
  .kpi-label { font-size: 12px; color: var(--muted); margin-bottom: 6px; }
  .kpi-value { font-size: 24px; font-weight: 600; }
  .kpi-value.green { color: var(--green); }
  .charts-row { display: grid; gap: 16px; margin-bottom: 16px; }
  .charts-row.cols2 { grid-template-columns: 1fr 1fr; }
  .charts-row.cols3 { grid-template-columns: 2fr 1fr; }
  .card { background: var(--surface); border: 1px solid var(--border); border-radius: 14px; padding: 1.25rem; }
  .card-title { font-size: 13px; font-weight: 600; color: var(--muted); text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 1rem; }
  .legend { display: flex; flex-wrap: wrap; gap: 10px; margin-bottom: 10px; font-size: 12px; color: var(--muted); }
  .legend span { display: flex; align-items: center; gap: 5px; }
  .legend-dot { width: 10px; height: 10px; border-radius: 3px; flex-shrink: 0; }
  table { width: 100%; border-collapse: collapse; font-size: 13px; }
  th { text-align: left; padding: 8px; color: var(--muted); font-weight: 600; font-size: 11px; text-transform: uppercase; letter-spacing: 0.05em; border-bottom: 1px solid var(--border); }
  td { padding: 8px; border-bottom: 1px solid var(--border); }
  tr:last-child td { border-bottom: none; }
  .badge { display: inline-block; padding: 3px 10px; border-radius: 999px; font-size: 11px; font-weight: 600; }
  .badge-green { background: var(--green-bg); color: var(--green); }
  .badge-amber { background: var(--amber-bg); color: var(--amber); }
  .badge-blue { background: var(--blue-bg); color: var(--blue); }
  footer { margin-top: 2rem; text-align: center; font-size: 12px; color: var(--muted); }
  @media (max-width: 700px) {
    body { padding: 1rem; }
    .charts-row.cols2, .charts-row.cols3 { grid-template-columns: 1fr; }
  }
</style>
</head>
<body>

<header>
  <div class="logo">Car<span>Good</span></div>
  <div class="sub">Painel de Gestão de Vendas</div>
</header>

<div class="kpi-grid">
  <div class="kpi"><div class="kpi-label">Total de vendas</div><div class="kpi-value">20</div></div>
  <div class="kpi"><div class="kpi-label">Faturamento total</div><div class="kpi-value green">R$ 2,07M</div></div>
  <div class="kpi"><div class="kpi-label">Ticket médio</div><div class="kpi-value">R$ 103,5K</div></div>
  <div class="kpi"><div class="kpi-label">Vendedores ativos</div><div class="kpi-value">20</div></div>
</div>

<div class="charts-row cols2">
  <div class="card">
    <div class="card-title">Faturamento por marca</div>
    <div class="legend">
      <span><span class="legend-dot" style="background:#1D9E75"></span>Toyota</span>
      <span><span class="legend-dot" style="background:#185FA5"></span>Honda</span>
      <span><span class="legend-dot" style="background:#D85A30"></span>Ford</span>
      <span><span class="legend-dot" style="background:#BA7517"></span>Chevrolet</span>
      <span><span class="legend-dot" style="background:#534AB7"></span>Volkswagen</span>
    </div>
    <div style="position:relative;height:240px"><canvas id="chartMarca"></canvas></div>
  </div>
  <div class="card">
    <div class="card-title">Forma de pagamento</div>
    <div class="legend">
      <span><span class="legend-dot" style="background:#1D9E75"></span>Financiamento 35%</span>
      <span><span class="legend-dot" style="background:#185FA5"></span>À vista 35%</span>
      <span><span class="legend-dot" style="background:#D85A30"></span>Cartão 30%</span>
    </div>
    <div style="position:relative;height:240px"><canvas id="chartPgto"></canvas></div>
  </div>
</div>

<div class="charts-row cols2">
  <div class="card">
    <div class="card-title">Top vendedores — faturamento</div>
    <div style="position:relative;height:300px"><canvas id="chartVend"></canvas></div>
  </div>
  <div class="card">
    <div class="card-title">Ticket médio por marca</div>
    <div style="position:relative;height:300px"><canvas id="chartTicket"></canvas></div>
  </div>
</div>

<div class="charts-row cols3">
  <div class="card">
    <div class="card-title">Últimas vendas</div>
    <table>
      <thead><tr><th>#</th><th>Cliente</th><th>Modelo</th><th>Vendedor</th><th>Valor</th><th>Pagamento</th></tr></thead>
      <tbody id="tblVendas"></tbody>
    </table>
  </div>
  <div class="card">
    <div class="card-title">Vendas por combustível</div>
    <div class="legend">
      <span><span class="legend-dot" style="background:#1D9E75"></span>Flex</span>
      <span><span class="legend-dot" style="background:#BA7517"></span>Gasolina</span>
      <span><span class="legend-dot" style="background:#534AB7"></span>Diesel</span>
    </div>
    <div style="position:relative;height:220px"><canvas id="chartComb"></canvas></div>
  </div>
</div>

<footer>CarGood &mdash; Sistema de Gestão de Vendas de Veículos &bull; Gerado via SQL Server</footer>

<script>
const vendas = [
  {id:1,cliente:'João Silva',marca:'Toyota',modelo:'Corolla',vendedor:'Carlos Mendes',valor:95000,pgto:'À vista',comb:'Flex'},
  {id:2,cliente:'Maria Souza',marca:'Toyota',modelo:'Hilux',vendedor:'Fernanda Rocha',valor:180000,pgto:'Financiamento',comb:'Diesel'},
  {id:3,cliente:'Carlos Lima',marca:'Toyota',modelo:'Yaris',vendedor:'João Silva',valor:75000,pgto:'Cartão',comb:'Flex'},
  {id:4,cliente:'Ana Paula',marca:'Honda',modelo:'Civic',vendedor:'Maria Oliveira',valor:85000,pgto:'À vista',comb:'Gasolina'},
  {id:5,cliente:'Pedro Santos',marca:'Honda',modelo:'City',vendedor:'Ricardo Alves',valor:70000,pgto:'Financiamento',comb:'Flex'},
  {id:6,cliente:'Lucas Alves',marca:'Honda',modelo:'HR-V',vendedor:'Juliana Martins',valor:120000,pgto:'Cartão',comb:'Flex'},
  {id:7,cliente:'Fernanda Rocha',marca:'Ford',modelo:'Ka',vendedor:'Paulo Henrique',valor:40000,pgto:'À vista',comb:'Flex'},
  {id:8,cliente:'Bruno Costa',marca:'Ford',modelo:'Ranger',vendedor:'Ana Beatriz',valor:160000,pgto:'Financiamento',comb:'Diesel'},
  {id:9,cliente:'Juliana Martins',marca:'Ford',modelo:'EcoSport',vendedor:'Marcos Vinicius',valor:90000,pgto:'Cartão',comb:'Flex'},
  {id:10,cliente:'Rafael Mendes',marca:'Chevrolet',modelo:'Onix',vendedor:'Camila Rocha',valor:85000,pgto:'À vista',comb:'Flex'},
  {id:11,cliente:'Camila Freitas',marca:'Chevrolet',modelo:'Tracker',vendedor:'Felipe Santos',valor:110000,pgto:'Financiamento',comb:'Flex'},
  {id:12,cliente:'Ricardo Gomes',marca:'Chevrolet',modelo:'S10',vendedor:'Larissa Costa',valor:130000,pgto:'Cartão',comb:'Diesel'},
  {id:13,cliente:'Patricia Lima',marca:'Volkswagen',modelo:'Gol',vendedor:'Gabriel Mendes',valor:35000,pgto:'À vista',comb:'Flex'},
  {id:14,cliente:'Eduardo Nunes',marca:'Volkswagen',modelo:'Polo',vendedor:'Patrícia Gomes',valor:80000,pgto:'Financiamento',comb:'Flex'},
  {id:15,cliente:'Vanessa Oliveira',marca:'Volkswagen',modelo:'Virtus',vendedor:'Thiago Ferreira',valor:95000,pgto:'Cartão',comb:'Flex'},
  {id:16,cliente:'Thiago Ribeiro',marca:'Volkswagen',modelo:'Jetta',vendedor:'Vanessa Lima',valor:140000,pgto:'À vista',comb:'Gasolina'},
  {id:17,cliente:'Aline Cardoso',marca:'Volkswagen',modelo:'T-Cross',vendedor:'Bruno Cardoso',valor:125000,pgto:'Financiamento',comb:'Flex'},
  {id:18,cliente:'Gabriel Duarte',marca:'Toyota',modelo:'Camry',vendedor:'Carolina Dias',valor:150000,pgto:'À vista',comb:'Gasolina'},
  {id:19,cliente:'Larissa Teixeira',marca:'Honda',modelo:'Accord',vendedor:'Eduardo Ramos',valor:135000,pgto:'Cartão',comb:'Gasolina'},
  {id:20,cliente:'Marcos Vinicius',marca:'Ford',modelo:'Fusion',vendedor:'Sofia Almeida',valor:145000,pgto:'Financiamento',comb:'Gasolina'},
];

const fmt = v => 'R$ '+(v/1000).toFixed(0)+'K';
const marcas = ['Toyota','Honda','Ford','Chevrolet','Volkswagen'];
const marcaColors = {Toyota:'#1D9E75',Honda:'#185FA5',Ford:'#D85A30',Chevrolet:'#BA7517',Volkswagen:'#534AB7'};

new Chart(document.getElementById('chartMarca'),{
  type:'bar',
  data:{labels:marcas,datasets:[{data:marcas.map(m=>vendas.filter(v=>v.marca===m).reduce((s,v)=>s+v.valor,0)),backgroundColor:marcas.map(m=>marcaColors[m]),borderRadius:5}]},
  options:{responsive:true,maintainAspectRatio:false,plugins:{legend:{display:false}},scales:{y:{ticks:{callback:v=>fmt(v)},grid:{color:'rgba(128,128,128,0.08)'}},x:{grid:{display:false}}}}
});

new Chart(document.getElementById('chartPgto'),{
  type:'doughnut',
  data:{labels:['Financiamento','À vista','Cartão'],datasets:[{data:[7,7,6],backgroundColor:['#1D9E75','#185FA5','#D85A30'],borderWidth:0,hoverOffset:8}]},
  options:{responsive:true,maintainAspectRatio:false,cutout:'65%',plugins:{legend:{display:false}}}
});

const vendMap={};
vendas.forEach(v=>{if(!vendMap[v.vendedor])vendMap[v.vendedor]=0;vendMap[v.vendedor]+=v.valor;});
const vendSort=Object.entries(vendMap).sort((a,b)=>b[1]-a[1]).slice(0,10);
new Chart(document.getElementById('chartVend'),{
  type:'bar',
  data:{labels:vendSort.map(e=>e[0].split(' ')[0]),datasets:[{data:vendSort.map(e=>e[1]),backgroundColor:'#185FA5',borderRadius:4}]},
  options:{indexAxis:'y',responsive:true,maintainAspectRatio:false,plugins:{legend:{display:false}},scales:{x:{ticks:{callback:v=>fmt(v)},grid:{color:'rgba(128,128,128,0.08)'}},y:{grid:{display:false}}}}
});

new Chart(document.getElementById('chartTicket'),{
  type:'bar',
  data:{labels:marcas,datasets:[{data:marcas.map(m=>{const vs=vendas.filter(v=>v.marca===m);return Math.round(vs.reduce((s,v)=>s+v.valor,0)/vs.length);}),backgroundColor:marcas.map(m=>marcaColors[m]+'cc'),borderRadius:5}]},
  options:{responsive:true,maintainAspectRatio:false,plugins:{legend:{display:false}},scales:{y:{ticks:{callback:v=>fmt(v)},grid:{color:'rgba(128,128,128,0.08)'}},x:{grid:{display:false}}}}
});

new Chart(document.getElementById('chartComb'),{
  type:'doughnut',
  data:{labels:['Flex','Gasolina','Diesel'],datasets:[{data:['Flex','Gasolina','Diesel'].map(c=>vendas.filter(v=>v.comb===c).length),backgroundColor:['#1D9E75','#BA7517','#534AB7'],borderWidth:0,hoverOffset:8}]},
  options:{responsive:true,maintainAspectRatio:false,cutout:'60%',plugins:{legend:{display:false}}}
});

const pgtoClass={'À vista':'badge-blue','Financiamento':'badge-green','Cartão':'badge-amber'};
const tbody=document.getElementById('tblVendas');
[...vendas].reverse().slice(0,10).forEach(v=>{
  const tr=document.createElement('tr');
  tr.innerHTML=`<td>${v.id}</td><td>${v.cliente}</td><td>${v.marca} ${v.modelo}</td><td>${v.vendedor.split(' ')[0]}</td><td style="font-weight:600">${fmt(v.valor)}</td><td><span class="badge ${pgtoClass[v.pgto]}">${v.pgto}</span></td>`;
  tbody.appendChild(tr);
});
</script>
</body>
</html>
