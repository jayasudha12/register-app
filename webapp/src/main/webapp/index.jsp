<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Blog Writer + Registration | Interactive WebApp</title>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">

<style>
  :root{
    --bg1:#0b1220;
    --bg2:#0f172a;
    --card: rgba(255,255,255,0.08);
    --stroke: rgba(255,255,255,0.16);
    --text: #e5e7eb;
    --muted:#a1a1aa;
    --accent1:#22c55e;
    --accent2:#06b6d4;
    --accent3:#a855f7;
    --danger:#ef4444;
    --shadow: 0 20px 60px rgba(0,0,0,0.50);
  }

  *{ box-sizing:border-box; margin:0; padding:0; font-family:"Poppins",sans-serif; }

  body{
    min-height:100vh;
    color: var(--text);
    background:
      radial-gradient(1200px 600px at 15% 15%, rgba(6,182,212,0.22), transparent 70%),
      radial-gradient(900px 500px at 90% 10%, rgba(34,197,94,0.18), transparent 60%),
      radial-gradient(700px 500px at 70% 90%, rgba(168,85,247,0.20), transparent 60%),
      linear-gradient(135deg, var(--bg1), var(--bg2));
    padding: 26px 14px;
    overflow-x:hidden;
  }

  /* Floating blobs */
  .blob{
    position:fixed;
    filter: blur(42px);
    opacity:0.40;
    z-index:-1;
    animation: float 9s ease-in-out infinite;
  }
  .blob.one{ width:320px;height:320px; left:-140px; top:90px; background: var(--accent2); }
  .blob.two{ width:300px;height:300px; right:-140px; top:160px; background: var(--accent1); animation-delay:1.6s; }
  .blob.three{ width:240px;height:240px; right:10%; bottom:-120px; background: var(--accent3); animation-delay:2.9s; }

  @keyframes float{
    0%,100%{ transform: translateY(0px) translateX(0px) scale(1); }
    50%{ transform: translateY(-30px) translateX(18px) scale(1.05); }
  }

  .topbar{
    width:min(1200px,100%);
    margin:0 auto 18px;
    display:flex;
    justify-content:space-between;
    align-items:center;
    gap:14px;
    padding: 14px 16px;
    border-radius: 18px;
    background: rgba(255,255,255,0.06);
    border: 1px solid rgba(255,255,255,0.12);
    box-shadow: 0 8px 30px rgba(0,0,0,0.25);
    backdrop-filter: blur(14px);
  }

  .brand{
    display:flex; align-items:center; gap:12px;
  }
  .brandIcon{
    width:44px;height:44px;border-radius:14px;
    display:grid;place-items:center;
    background: rgba(255,255,255,0.10);
    border: 1px solid rgba(255,255,255,0.14);
  }
  .brand h1{
    font-size:16px;
    line-height:1.1;
  }
  .brand p{
    font-size:12px;
    color: var(--muted);
  }

  .chipRow{
    display:flex;
    gap:10px;
    flex-wrap:wrap;
    justify-content:flex-end;
  }

  .chip{
    display:inline-flex;
    gap:8px;
    align-items:center;
    padding: 8px 12px;
    border-radius: 999px;
    background: rgba(255,255,255,0.06);
    border: 1px solid rgba(255,255,255,0.12);
    font-size:12px;
    color: #dbeafe;
    user-select:none;
  }
  .dot{
    width:8px;height:8px;border-radius:50%;
    background: linear-gradient(135deg, var(--accent2), var(--accent1));
    box-shadow: 0 0 0 4px rgba(6,182,212,0.12);
  }

  .wrapper{
    width:min(1200px,100%);
    margin:0 auto;
    display:grid;
    grid-template-columns: 1.35fr 0.65fr;
    gap:18px;
    animation: appear 0.8s ease forwards;
    transform: translateY(16px);
    opacity:0;
  }
  @keyframes appear{
    to{ opacity:1; transform: translateY(0); }
  }

  .card{
    border-radius: 22px;
    background: var(--card);
    border:1px solid var(--stroke);
    box-shadow: var(--shadow);
    backdrop-filter: blur(14px);
    -webkit-backdrop-filter: blur(14px);
    overflow:hidden;
  }

  .cardHeader{
    padding:18px 18px 12px;
    border-bottom: 1px solid rgba(255,255,255,0.10);
    display:flex;
    justify-content:space-between;
    align-items:flex-start;
    gap:14px;
  }
  .cardHeader h2{
    font-size: 18px;
  }
  .cardHeader p{
    margin-top:4px;
    color: var(--muted);
    font-size:12px;
  }

  .metaRow{
    display:flex;
    gap:10px;
    flex-wrap:wrap;
    justify-content:flex-end;
    text-align:right;
  }
  .pill{
    font-size:11px;
    padding:8px 10px;
    border-radius:999px;
    border:1px solid rgba(255,255,255,0.14);
    background: rgba(2,6,23,0.35);
    color:#e2e8f0;
  }

  /* BLOG EDITOR */
  .editorBody{
    padding:16px 18px 18px;
  }

  .grid2{
    display:grid;
    grid-template-columns: 1.1fr 0.9fr;
    gap:14px;
  }

  label{
    font-size:12px;
    color:#cbd5e1;
    display:block;
    margin: 10px 0 6px;
  }

  .inputWrap{ position:relative; }

  input, textarea{
    width:100%;
    padding:12px 12px 12px 42px;
    border-radius:14px;
    outline:none;
    border:1px solid rgba(255,255,255,0.14);
    background: rgba(3,7,18,0.35);
    color: var(--text);
    transition:0.2s ease;
    font-size:13px;
  }
  textarea{
    min-height: 250px;
    resize: vertical;
    padding:12px 14px 12px 14px;
  }
  input:focus, textarea:focus{
    border-color: rgba(6,182,212,0.55);
    box-shadow: 0 0 0 4px rgba(6,182,212,0.12);
  }
  .icon{
    position:absolute;
    left:12px;
    top:50%;
    transform: translateY(-50%);
    opacity:0.9;
    font-size:16px;
  }

  .hint{
    margin-top:6px;
    font-size:11px;
    color: var(--muted);
  }

  .toolbar{
    display:flex;
    gap:10px;
    flex-wrap:wrap;
    margin-top:10px;
  }

  .toolBtn{
    border:none;
    cursor:pointer;
    padding:10px 12px;
    border-radius:14px;
    font-weight:700;
    font-size:12px;
    color:#001;
    background: linear-gradient(135deg, var(--accent2), var(--accent1));
    transition:0.25s ease;
  }
  .toolBtn.secondary{
    background: rgba(255,255,255,0.08);
    border:1px solid rgba(255,255,255,0.14);
    color:#e5e7eb;
  }
  .toolBtn:hover{ transform: translateY(-2px); }
  .toolBtn:active{ transform: translateY(0px); }

  .preview{
    margin-top:14px;
    border-radius:18px;
    border:1px solid rgba(255,255,255,0.12);
    background: rgba(2,6,23,0.25);
    padding:16px;
    overflow:hidden;
  }
  .previewTitle{
    font-weight:800;
    font-size:16px;
    margin-bottom:6px;
  }
  .previewMeta{
    font-size:12px;
    color: var(--muted);
    margin-bottom:12px;
  }
  .previewContent{
    font-size:13px;
    line-height:1.65;
    color:#e2e8f0;
    white-space:pre-wrap;
  }
  .tag{
    display:inline-flex;
    padding:6px 10px;
    border-radius:999px;
    background: rgba(6,182,212,0.14);
    border:1px solid rgba(6,182,212,0.22);
    font-size:11px;
    margin-right:6px;
    margin-top:6px;
  }

  .imageBox{
    margin-top:12px;
    padding:12px;
    border-radius:18px;
    border:1px dashed rgba(255,255,255,0.20);
    background: rgba(255,255,255,0.05);
    display:flex;
    gap:12px;
    align-items:center;
  }
  .imagePreview{
    width:86px;height:64px;
    border-radius:16px;
    border:1px solid rgba(255,255,255,0.14);
    overflow:hidden;
    display:grid;
    place-items:center;
    background: rgba(2,6,23,0.30);
    flex-shrink:0;
  }
  .imagePreview img{
    width:100%;
    height:100%;
    object-fit:cover;
    display:none;
  }
  .imageBox small{
    color: var(--muted);
    font-size:12px;
    line-height:1.4;
  }

  /* FORM (Right column) */
  .sideBody{ padding: 16px 18px 18px; }

  .stack{
    display:grid;
    gap:10px;
  }

  .btn{
    width:100%;
    padding:12px 14px;
    border:none;
    border-radius:16px;
    cursor:pointer;
    font-weight:800;
    color:#001;
    background: linear-gradient(135deg, var(--accent2), var(--accent1));
    transition:0.25s ease;
    position:relative;
    overflow:hidden;
  }
  .btn:hover{ transform: translateY(-2px); }
  .btn.secondary{
    color:#e5e7eb;
    background: rgba(255,255,255,0.08);
    border:1px solid rgba(255,255,255,0.14);
  }

  .msg{
    display:none;
    margin-top:10px;
    padding:10px 12px;
    border-radius:14px;
    font-size:12px;
    border:1px solid rgba(255,255,255,0.12);
  }
  .msg.success{
    color:#bbf7d0;
    background: rgba(34,197,94,0.14);
    border-color: rgba(34,197,94,0.25);
  }
  .msg.error{
    color:#fecaca;
    background: rgba(239,68,68,0.15);
    border-color: rgba(239,68,68,0.25);
  }

  .footer{
    text-align:center;
    font-size:12px;
    color: var(--muted);
    margin-top:10px;
  }

  @media(max-width: 980px){
    .wrapper{ grid-template-columns:1fr; }
    .metaRow{ justify-content:flex-start; text-align:left; }
    .grid2{ grid-template-columns:1fr; }
  }
</style>
</head>

<body>
  <div class="blob one"></div>
  <div class="blob two"></div>
  <div class="blob three"></div>

  <!-- TOP BAR -->
  <header class="topbar">
    <div class="brand">
      <div class="brandIcon">📝</div>
      <div>
        <h1>Blog Writer WebApp</h1>
        <p>Create blogs, save drafts & publish easily</p>
      </div>
    </div>

    <div class="chipRow">
      <div class="chip"><span class="dot"></span> Auto-save Draft</div>
      <div class="chip"><span class="dot"></span> Live Preview</div>
      <div class="chip"><span class="dot"></span> Tags + Image</div>
    </div>
  </header>

  <main class="wrapper">

    <!-- BLOG EDITOR -->
    <section class="card">
      <div class="cardHeader">
        <div>
          <h2>Write Your Blog ✍️</h2>
          <p>Type your article and see live preview + stats</p>
        </div>
        <div class="metaRow">
          <div class="pill">Words: <b id="wordCount">0</b></div>
          <div class="pill">Reading Time: <b id="readTime">0 min</b></div>
          <div class="pill">Status: <b id="draftStatus">Draft</b></div>
        </div>
      </div>

      <div class="editorBody">
        <div class="grid2">
          <div>
            <label for="blogTitle">Blog Title</label>
            <div class="inputWrap">
              <span class="icon">🏷️</span>
              <input id="blogTitle" type="text" placeholder="Example: How I prepared for DevOps interviews" />
            </div>

            <label for="blogAuthor">Author Name</label>
            <div class="inputWrap">
              <span class="icon">👤</span>
              <input id="blogAuthor" type="text" placeholder="Your name" />
            </div>

            <label for="blogTags">Tags (comma separated)</label>
            <div class="inputWrap">
              <span class="icon">#</span>
              <input id="blogTags" type="text" placeholder="devops, aws, docker, kubernetes" />
            </div>

            <div class="imageBox">
              <div class="imagePreview" id="imgBox">
                <img id="imgPreview" alt="blog cover preview">
                <span id="imgPlaceholder">🖼️</span>
              </div>
              <div>
                <label for="blogImage" style="margin:0 0 6px;">Cover Image</label>
                <input id="blogImage" type="file" accept="image/*" style="padding-left:12px;">
                <small>Optional: Upload a cover image to make blog more professional.</small>
              </div>
            </div>

            <div class="toolbar">
              <button type="button" class="toolBtn secondary" onclick="clearDraft()">🧹 Clear</button>
              <button type="button" class="toolBtn secondary" onclick="loadDraft()">📥 Load Draft</button>
              <button type="button" class="toolBtn" onclick="saveDraft()">💾 Save Draft</button>
              <button type="button" class="toolBtn" onclick="publishBlog()">🚀 Publish</button>
            </div>

            <div id="blogMsg" class="msg"></div>
          </div>

          <div>
            <label for="blogContent">Blog Content</label>
            <textarea id="blogContent" placeholder="Write your blog content here..."></textarea>
            <div class="hint">Tip: Use headings and short paragraphs to make it easy to read.</div>
          </div>
        </div>

        <div class="preview">
          <div class="previewTitle" id="pTitle">Your blog title will appear here</div>
          <div class="previewMeta" id="pMeta">by Author • tags</div>
          <div id="pTags"></div>
          <div class="previewContent" id="pContent">Start writing and your content will show here instantly…</div>
        </div>
      </div>
    </section>

    <!-- REGISTRATION FORM -->
    <aside class="card">
      <div class="cardHeader">
        <div>
          <h2>Registration Form ✅</h2>
          <p>Create account to save blogs & publish.</p>
        </div>
      </div>

      <!-- Change action to servlet mapping if needed -->
      <form id="regForm" class="sideBody" action="action_page.php" method="post" novalidate>
        <div class="stack">
          <div>
            <label for="Name">Full Name</label>
            <div class="inputWrap">
              <span class="icon">👤</span>
              <input type="text" id="Name" name="Name" placeholder="Enter full name" required>
            </div>
          </div>

          <div>
            <label for="mobile">Mobile</label>
            <div class="inputWrap">
              <span class="icon">📱</span>
              <input type="text" id="mobile" name="mobile" placeholder="10-digit number" required>
            </div>
          </div>

          <div>
            <label for="email">Email</label>
            <div class="inputWrap">
              <span class="icon">📧</span>
              <input type="email" id="email" name="email" placeholder="example@gmail.com" required>
            </div>
          </div>

          <div>
            <label for="psw">Password</label>
            <div class="inputWrap">
              <span class="icon">🔒</span>
              <input type="password" id="psw" name="psw" placeholder="Create password" required>
            </div>
          </div>

          <div>
            <label for="psw-repeat">Confirm Password</label>
            <div class="inputWrap">
              <span class="icon">✅</span>
              <input type="password" id="psw-repeat" name="psw-repeat" placeholder="Confirm password" required>
            </div>
          </div>

          <button class="btn" type="submit">Create Account</button>
          <button class="btn secondary" type="button" onclick="quickFill()">⚡ Quick Fill Demo</button>

          <div id="formError" class="msg error"></div>
          <div id="formSuccess" class="msg success"></div>

          <div class="footer">💡 This is a front-end demo. You can connect servlet + MySQL anytime.</div>
        </div>
      </form>
    </aside>

  </main>

<script>
  // ===============================
  // BLOG: live preview + stats
  // ===============================
  const blogTitle = document.getElementById("blogTitle");
  const blogAuthor = document.getElementById("blogAuthor");
  const blogTags = document.getElementById("blogTags");
  const blogContent = document.getElementById("blogContent");

  const pTitle = document.getElementById("pTitle");
  const pMeta = document.getElementById("pMeta");
  const pContent = document.getElementById("pContent");
  const pTags = document.getElementById("pTags");

  const wordCount = document.getElementById("wordCount");
  const readTime = document.getElementById("readTime");
  const draftStatus = document.getElementById("draftStatus");
  const blogMsg = document.getElementById("blogMsg");

  function countWords(text){
    const trimmed = text.trim();
    if(!trimmed) return 0;
    return trimmed.split(/\s+/).length;
  }

  function readingTime(words){
    // avg reading speed 200 wpm
    return Math.max(1, Math.ceil(words / 200));
  }

  function renderTags(tagText){
    pTags.innerHTML = "";
    const tags = tagText.split(",").map(t=>t.trim()).filter(Boolean);
    tags.slice(0, 12).forEach(t=>{
      const span = document.createElement("span");
      span.className = "tag";
      span.textContent = "#" + t.replace(/^#/, "");
      pTags.appendChild(span);
    });
    return tags;
  }

  function updatePreview(){
    const title = blogTitle.value.trim() || "Your blog title will appear here";
    const author = blogAuthor.value.trim() || "Author";
    const tags = renderTags(blogTags.value.trim());
    const content = blogContent.value.trim() || "Start writing and your content will show here instantly…";

    pTitle.textContent = title;
    pMeta.textContent = `by ${author} • ${tags.length ? (tags.length + " tags") : "no tags"}`;
    pContent.textContent = content;

    const wc = countWords(content);
    wordCount.textContent = wc;
    readTime.textContent = readingTime(wc) + " min";
  }

  [blogTitle, blogAuthor, blogTags, blogContent].forEach(el=>{
    el.addEventListener("input", () => {
      updatePreview();
      autoSaveDraft();
    });
  });

  // ===============================
  // BLOG: image upload preview
  // ===============================
  const blogImage = document.getElementById("blogImage");
  const imgPreview = document.getElementById("imgPreview");
  const imgPlaceholder = document.getElementById("imgPlaceholder");

  blogImage.addEventListener("change", () => {
    const file = blogImage.files[0];
    if(!file) return;

    const reader = new FileReader();
    reader.onload = () => {
      imgPreview.src = reader.result;
      imgPreview.style.display = "block";
      imgPlaceholder.style.display = "none";
      localStorage.setItem("BLOG_COVER", reader.result);
    };
    reader.readAsDataURL(file);
  });

  // ===============================
  // BLOG: autosave to localStorage
  // ===============================
  function autoSaveDraft(){
    const data = {
      title: blogTitle.value,
      author: blogAuthor.value,
      tags: blogTags.value,
      content: blogContent.value,
      savedAt: new Date().toISOString()
    };
    localStorage.setItem("BLOG_DRAFT", JSON.stringify(data));
    draftStatus.textContent = "Draft (Auto-saved)";
  }

  function saveDraft(){
    autoSaveDraft();
    showBlogMessage("✅ Draft saved successfully!");
  }

  function loadDraft(){
    const raw = localStorage.getItem("BLOG_DRAFT");
    if(!raw) return showBlogMessage("❌ No saved draft found.", true);

    const data = JSON.parse(raw);
    blogTitle.value = data.title || "";
    blogAuthor.value = data.author || "";
    blogTags.value = data.tags || "";
    blogContent.value = data.content || "";

    const cover = localStorage.getItem("BLOG_COVER");
    if(cover){
      imgPreview.src = cover;
      imgPreview.style.display = "block";
      imgPlaceholder.style.display = "none";
    }

    draftStatus.textContent = "Draft (Loaded)";
    updatePreview();
    showBlogMessage("📥 Draft loaded successfully!");
  }

  function clearDraft(){
    blogTitle.value = "";
    blogAuthor.value = "";
    blogTags.value = "";
    blogContent.value = "";
    pTags.innerHTML = "";

    imgPreview.src = "";
    imgPreview.style.display = "none";
    imgPlaceholder.style.display = "block";

    localStorage.removeItem("BLOG_DRAFT");
    localStorage.removeItem("BLOG_COVER");

    draftStatus.textContent = "Draft";
    updatePreview();
    showBlogMessage("🧹 Cleared! Start fresh.");
  }

  function publishBlog(){
    const t = blogTitle.value.trim();
    const a = blogAuthor.value.trim();
    const c = blogContent.value.trim();

    if(t.length < 5) return showBlogMessage("❌ Add a proper title (min 5 characters).", true);
    if(a.length < 2) return showBlogMessage("❌ Add author name.", true);
    if(countWords(c) < 30) return showBlogMessage("❌ Blog content too short (min 30 words).", true);

    draftStatus.textContent = "Published ✅";
    showBlogMessage("🚀 Published successfully! (Demo publish)", false);
  }

  function showBlogMessage(msg, isError=false){
    blogMsg.style.display = "block";
    blogMsg.className = "msg " + (isError ? "error" : "success");
    blogMsg.textContent = msg;
    setTimeout(()=> blogMsg.style.display="none", 2600);
  }

  // ===============================
  // FORM VALIDATION
  // ===============================
  const regForm = document.getElementById("regForm");
  const formError = document.getElementById("formError");
  const formSuccess = document.getElementById("formSuccess");

  function showFormError(msg){
    formSuccess.style.display = "none";
    formError.textContent = "❌ " + msg;
    formError.style.display = "block";
  }
  function showFormSuccess(msg){
    formError.style.display = "none";
    formSuccess.textContent = "✅ " + msg;
    formSuccess.style.display = "block";
  }

  regForm.addEventListener("submit", function(e){
    e.preventDefault();

    const name = document.getElementById("Name").value.trim();
    const mobile = document.getElementById("mobile").value.trim();
    const email = document.getElementById("email").value.trim();
    const psw = document.getElementById("psw").value;
    const psw2 = document.getElementById("psw-repeat").value;

    if(name.length < 3) return showFormError("Name must be at least 3 characters.");
    if(!/^\d{10}$/.test(mobile)) return showFormError("Mobile must be exactly 10 digits.");
    if(email.length < 6 || !email.includes("@")) return showFormError("Enter a valid email address.");
    if(psw.length < 6) return showFormError("Password must be at least 6 characters.");
    if(psw !== psw2) return showFormError("Passwords do not match.");

    showFormSuccess("Account created successfully! (Demo)");
    setTimeout(()=> regForm.submit(), 1000);
  });

  function quickFill(){
    document.getElementById("Name").value = "Demo User";
    document.getElementById("mobile").value = "9876543210";
    document.getElementById("email").value = "demo@gmail.com";
    document.getElementById("psw").value = "demo123";
    document.getElementById("psw-repeat").value = "demo123";
    showFormSuccess("Auto-filled demo details ✅");
  }

  // Load draft automatically if exists
  function tryAutoLoad(){
    const raw = localStorage.getItem("BLOG_DRAFT");
    const cover = localStorage.getItem("BLOG_COVER");
    if(raw){
      const data = JSON.parse(raw);
      blogTitle.value = data.title || "";
      blogAuthor.value = data.author || "";
      blogTags.value = data.tags || "";
      blogContent.value = data.content || "";
      draftStatus.textContent = "Draft (Auto-loaded)";
    }
    if(cover){
      imgPreview.src = cover;
      imgPreview.style.display = "block";
      imgPlaceholder.style.display = "none";
    }
    updatePreview();
  }

  // init
  tryAutoLoad();
  updatePreview();
</script>

</body>
</html>
