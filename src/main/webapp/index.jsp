<%--
  Created by IntelliJ IDEA.
  User: 13316
  Date: 2025/3/16
  Time: 1:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>NoteSaver - Your Personal Note Application</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 20px;
      background-color: #f5f5f5;
    }
    .container {
      max-width: 1200px;
      margin: 0 auto;
    }
    .header {
      background-color: #4285f4;
      color: white;
      padding: 20px;
      border-radius: 5px;
      margin-bottom: 20px;
    }
    .debug-section {
      background-color: #ffecb3;
      border: 1px solid #ffcc00;
      padding: 15px;
      margin-bottom: 20px;
      border-radius: 5px;
    }
    .layout-container {
      display: flex;
      gap: 20px;
      margin-bottom: 20px;
    }

    .note-index-container {
      flex: 1;
      max-width: 300px;
      background-color: white;
      border-radius: 5px;
      box-shadow: 0 2px 5px rgba(0,0,0,0.1);
      padding: 15px;
    }

    .note-detail-container {
      flex: 3;
      background-color: white;
      border-radius: 5px;
      box-shadow: 0 2px 5px rgba(0,0,0,0.1);
      padding: 15px;
    }

    .note-index {
      max-height: 500px;
      overflow-y: auto;
    }

    .index-item {
      padding: 8px 12px;
      border-bottom: 1px solid #eee;
      cursor: pointer;
      transition: background-color 0.2s;
      display: flex;
      align-items: center;
    }

    .index-item:hover {
      background-color: #f5f5f5;
    }

    .index-item.active {
      background-color: #e3f2fd;
      border-left: 3px solid #2196f3;
    }

    .index-item-icon {
      margin-right: 8px;
      width: 20px;
      height: 20px;
      text-align: center;
      line-height: 20px;
      border-radius: 50%;
      font-size: 12px;
      color: white;
    }

    .index-item-icon.text {
      background-color: #4285f4;
    }

    .index-item-icon.url {
      background-color: #0f9d58;
    }

    .index-item-icon.image {
      background-color: #f4b400;
    }

    .index-item-icon.combined {
      background-color: #db4437;
    }

    .index-item-label {
      flex: 1;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    .note-detail {
      min-height: 200px;
    }

    @media (max-width: 768px) {
      .layout-container {
        flex-direction: column;
      }

      .note-index-container {
        max-width: none;
      }
    }
    .note-list {
      display: flex;
      flex-wrap: wrap;
      gap: 20px;
    }
    .note-card {
      background-color: white;
      border-radius: 5px;
      padding: 15px;
      box-shadow: 0 2px 5px rgba(0,0,0,0.1);
      width: 300px;
    }
    .note-form {
      background-color: white;
      border-radius: 5px;
      padding: 20px;
      box-shadow: 0 2px 5px rgba(0,0,0,0.1);
      margin-bottom: 20px;
    }
    .form-group {
      margin-bottom: 15px;
    }
    .form-group label {
      display: block;
      margin-bottom: 5px;
      font-weight: bold;
    }
    .form-group input, .form-group textarea, .form-group select {
      width: 100%;
      padding: 8px;
      border: 1px solid #ddd;
      border-radius: 4px;
      box-sizing: border-box;
    }
    .btn {
      background-color: #4285f4;
      color: white;
      border: none;
      padding: 10px 15px;
      border-radius: 4px;
      cursor: pointer;
    }
    .btn:hover {
      background-color: #3367d6;
    }
    .tabs {
      display: flex;
      margin-bottom: 20px;
    }
    .combined-content {
      margin-top: 15px;
    }

    .component {
      margin-bottom: 15px;
      border: 1px solid #e0e0e0;
      border-radius: 4px;
      background-color: #fafafa;
      overflow: hidden;
    }

    /* Combined notes component styling */
    .component {
      margin-bottom: 15px;
      padding: 15px;
      background-color: #f9f9f9;
      border-radius: 4px;
      border-left: 3px solid #4285f4;
      position: relative;
    }

    .component-item {
      position: relative;
    }

    .btn-delete {
      background-color: #f44336;
      margin-top: 10px;
    }

    .btn-delete:hover {
      background-color: #d32f2f;
    }

    .add-component {
      display: flex;
      gap: 10px;
      align-items: center;
      margin-bottom: 15px;
    }

    .add-component select {
      flex-grow: 1;
      padding: 8px;
      border: 1px solid #ddd;
      border-radius: 4px;
    }

    #combined-components {
      margin-bottom: 20px;
    }

    .component-header {
      background-color: #f0f0f0;
      padding: 8px 12px;
      font-weight: bold;
      font-size: 14px;
      border-bottom: 1px solid #e0e0e0;
    }

    .component-body {
      padding: 12px;
    }

    .component-text .component-header {
      background-color: #e3f2fd;
      color: #1565c0;
    }

    .component-url .component-header {
      background-color: #e8f5e9;
      color: #2e7d32;
    }

    .component-image .component-header {
      background-color: #fff3e0;
      color: #e65100;
    }

    .component-body p {
      margin: 8px 0;
    }

    .component-body img {
      display: block;
      max-width: 100%;
      margin: 0 auto;
    }

    .component-body .caption {
      text-align: center;
      font-style: italic;
      color: #666;
      margin-top: 8px;
    }

    .component-body a {
      color: #0d47a1;
      word-break: break-all;
    }
    .tab {
      padding: 10px 20px;
      background-color: #e0e0e0;
      border: none;
      cursor: pointer;
      flex-grow: 1;
      text-align: center;
    }
    .tab.active {
      background-color: #4285f4;
      color: white;
    }
    .tab-content {
      display: none;
    }
    .tab-content.active {
      display: block;
    }
    .search-container {
      display: flex;
      margin-bottom: 20px;
    }

    #search-form {
      display: flex;
      width: 100%;
    }

    #search {
      flex-grow: 1;
      padding: 10px;
      border: 1px solid #ddd;
      border-radius: 4px 0 0 4px;
      box-sizing: border-box;
    }

    .search-btn {
      border-radius: 0 4px 4px 0;
      margin-left: -1px;
      padding: 0 15px;
    }

    .note-card {
      background-color: white;
      border-radius: 5px;
      padding: 15px;
      box-shadow: 0 2px 5px rgba(0,0,0,0.1);
      width: 300px;
      transition: transform 0.2s, box-shadow 0.2s;
      margin-bottom: 20px;
    }

    .note-card:hover {
      transform: translateY(-3px);
      box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    }

    .note-actions {
      margin-top: 15px;
      display: flex;
      justify-content: flex-end;
    }

    /* 搜索结果高亮 */
    .highlight {
      background-color: #ffeb3b;
      padding: 2px;
      border-radius: 2px;
    }
  </style>
</head>
<body>
<div class="container">
  <div class="header">
    <h1>NoteSaver</h1>
    <p>Your Personal Note Application</p>
  </div>

  <!-- Debug Information Section -->
  <div class="debug-section">
    <h2>Debug Information</h2>
    <p>Context Path: <%= request.getContextPath() %></p>
    <p>Servlet Path: <%= request.getServletPath() %></p>
    <p>Request URI: <%= request.getRequestURI() %></p>
    <p>Absolute Path: <%= application.getRealPath(request.getServletPath()) %></p>

    <h3>Debug Links</h3>
    <ul>
      <li><a href="<%= request.getContextPath() %>/health">Health Check</a></li>
      <li><a href="<%= request.getContextPath() %>/test">Test Servlet</a></li>
      <li><a href="<%= request.getContextPath() %>/api/notes">API Notes Endpoint</a></li>
    </ul>

    <h3>API Test</h3>
    <button onclick="testAPI()">Test API Connection</button>
    <div id="apiResult" style="margin-top: 10px; padding:.5em; background-color: #f0f0f0; border-radius: 4px;"></div>
  </div>

  <div class="tabs">
    <button class="tab active" data-tab="text">Text Notes</button>
    <button class="tab" data-tab="url">URL Notes</button>
    <button class="tab" data-tab="image">Image Notes</button>
  </div>

  <div class="tab-content active" id="text-tab">
    <div class="note-form">
      <h2>Add Text Note</h2>
      <div class="form-group">
        <label for="text-label">Label</label>
        <input type="text" id="text-label" name="label">
      </div>
      <div class="form-group">
        <label for="text-content">Content</label>
        <textarea id="text-content" name="content" rows="5"></textarea>
      </div>
      <button class="btn" onclick="saveTextNote()">Save</button>
    </div>
  </div>

  <div class="tab-content" id="url-tab">
    <div class="note-form">
      <h2>Add URL Note</h2>
      <div class="form-group">
        <label for="url-label">Label</label>
        <input type="text" id="url-label" name="label">
      </div>
      <div class="form-group">
        <label for="url-url">URL</label>
        <input type="url" id="url-url" name="url">
      </div>
      <div class="form-group">
        <label for="url-description">Description</label>
        <textarea id="url-description" name="description" rows="3"></textarea>
      </div>
      <button class="btn" onclick="saveUrlNote()">Save</button>
    </div>
  </div>

  <div class="tab-content" id="image-tab">
    <div class="note-form">
      <h2>Add Image Note</h2>
      <div class="form-group">
        <label for="image-label">Label</label>
        <input type="text" id="image-label" name="label">
      </div>
      <div class="form-group">
        <label for="image-file">Image</label>
        <input type="file" id="image-file" name="image" accept="image/*">
      </div>
      <div class="form-group">
        <label for="image-caption">Caption</label>
        <textarea id="image-caption" name="caption" rows="2"></textarea>
      </div>
      <button class="btn" onclick="saveImageNote()">Save</button>
    </div>
  </div>

  <h2>Your Notes</h2>
  <div class="form-group search-container">
    <form id="search-form" onsubmit="searchNotes(); return false;">
      <input type="text" id="search" placeholder="Search notes...">
      <button type="submit" class="btn search-btn">Search</button>
    </form>
  </div>

  <div class="layout-container">
    <div class="note-index-container">
      <h3>Note Index</h3>
      <div id="note-index" class="note-index">
        <!-- Note index will be displayed here -->
        <p>Loading index...</p>
      </div>
    </div>

    <div class="note-detail-container">
      <h3>Note Details</h3>
      <div id="note-detail" class="note-detail">
        <!-- Selected note detail will be displayed here -->
        <p>Select a note from the index to view details.</p>
      </div>
    </div>
  </div>

  <!-- 将原有的note-list区域改为隐藏 -->
  <div id="note-list" class="note-list" style="display: none;">
    <!-- Notes will be displayed here (now hidden) -->
  </div>
</div>

<script>
  function escapeHtml(unsafe) {
    if (!unsafe) return '';
    return unsafe.toString()
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#039;");
  }
  // Add these to your DOMContentLoaded event handler
  document.addEventListener('DOMContentLoaded', function() {
    // 设置标签切换
    document.querySelectorAll('.tab').forEach(tab => {
      tab.addEventListener('click', function() {
        document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
        document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
        this.classList.add('active');
        document.getElementById(this.dataset.tab + '-tab').classList.add('active');
      });
    });

    // 添加搜索表单事件监听
    const searchForm = document.getElementById('search-form');
    if (searchForm) {
      searchForm.addEventListener('submit', function(e) {
        e.preventDefault();
        searchNotes();
      });
    }

    // 为搜索输入框添加事件
    const searchInput = document.getElementById('search');
    if (searchInput) {
      searchInput.addEventListener('click', function() {
        this.focus();
      });

      let searchTimeout;
      searchInput.addEventListener('keyup', function() {
        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(searchNotes, 300);
      });
    }

    // 添加视图切换器
    addViewSwitcher();

    // 添加额外样式
    addAdditionalStyles();

    // 加载笔记
    loadNotes();
  });

  // 增加一些CSS样式
  function addAdditionalStyles() {
    const style = document.createElement('style');
    style.textContent = `
    .view-switcher {
      display: flex;
      align-items: center;
      margin-top: 10px;
      gap: 10px;
    }

    .view-switcher select {
      padding: 5px;
      border-radius: 4px;
      border: 1px solid #ddd;
    }

    .btn-edit {
      background-color: #4caf50;
    }

    .btn-edit:hover {
      background-color: #388e3c;
    }

    .note-summary {
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
      max-width: 200px;
      color: #666;
      font-size: 0.9em;
      margin-top: 5px;
    }
  `;
    document.head.appendChild(style);
  }

  // 实现视图切换
  function changeViewMode() {
    const viewMode = document.getElementById('view-mode').value;

    if (window.allNotes && window.allNotes.length > 0) {
      const notes = [...window.allNotes]; // 创建副本

      switch (viewMode) {
        case 'created':
          notes.sort((a, b) => new Date(a.creationTime) - new Date(b.creationTime));
          break;

        case 'modified':
          notes.sort((a, b) => new Date(b.lastModificationTime) - new Date(a.lastModificationTime));
          break;

        case 'alphabetical':
          notes.sort((a, b) => a.label.localeCompare(b.label));
          break;
      }

      // 重建索引
      buildNoteIndex(notes, viewMode === 'summary');

      // 保持选中状态
      const activeItem = document.querySelector('.index-item.active');
      if (activeItem) {
        const noteId = activeItem.dataset.id;
        const newActiveItem = document.querySelector(`.index-item[data-id="${noteId}"]`);
        if (newActiveItem) {
          newActiveItem.classList.add('active');
        } else if (notes.length > 0) {
          // 如果找不到原来选中的项，选中第一个
          displayNoteDetail(notes[0].id);
          const firstItem = document.querySelector('.index-item');
          if (firstItem) firstItem.classList.add('active');
        }
      }
    }
  }

  function deleteNote(noteId) {
    if (confirm('Are you sure you want to delete this note?')) {
      // 获取上下文路径
      const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1)) || '';

      fetch(contextPath + '/api/notes/' + noteId, {
        method: 'DELETE'
      })
              .then(response => {
                if (!response.ok) {
                  return response.text().then(text => {
                    throw new Error('Failed to delete note: ' + text);
                  });
                }
                return response.text();
              })
              .then(() => {
                // 删除成功后重新加载笔记
                loadNotes();
              })
              .catch(error => {
                console.error('Error deleting note:', error);
                alert('Error deleting note: ' + error.message);
              });
    }
  }

  function testAPI() {
    const apiResult = document.getElementById('apiResult');
    apiResult.innerHTML = "Testing API connection...";

    // Get the context path dynamically
    const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1)) || '';

    fetch(contextPath + '/api/notes')
            .then(response => {
              apiResult.innerHTML = '<p><strong>Status:</strong> ' + response.status + ' ' + response.statusText + '</p>' +
                      '<p><strong>Response Headers:</strong></p>' +
                      '<pre>' + formatHeaders(response.headers) + '</pre>';

              return response.text();
            })
            .then(text => {
              apiResult.innerHTML += '<p><strong>Response Body:</strong></p>' +
                      '<pre>' + text + '</pre>';

              try {
                JSON.parse(text);
                apiResult.innerHTML += "<p style='color: green;'>✅ Response is valid JSON</p>";
              } catch (e) {
                apiResult.innerHTML += "<p style='color: red;'>❌ Response is not valid JSON: " + e.message + "</p>";
              }
            })
            .catch(error => {
              apiResult.innerHTML = "<p style='color: red;'>Error: " + error.message + "</p>";
            });
  }

  function formatHeaders(headers) {
    let result = '';
    headers.forEach((value, name) => {
      result += name + ': ' + value + '\\n';
    });
    return result;
  }

  function saveTextNote() {
    const label = document.getElementById('text-label').value;
    const content = document.getElementById('text-content').value;

    if (!label || !content) {
      alert('Please fill in all fields');
      return;
    }

    // Get the context path dynamically
    const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1)) || '';

    fetch(contextPath + '/api/notes', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        type: 'TEXT',
        label: label,
        content: content
      })
    })
            .then(response => {
              if (response.ok) {
                clearForm('text');
                loadNotes();
              } else {
                // Get more detailed error information
                response.text().then(errorText => {
                  console.error('Server responded with error:', response.status, errorText);
                  alert('Error saving note: ' + response.status + ' ' + errorText);
                });
              }
            })
            .catch(error => {
              console.error('Error:', error);
              alert('Error saving note. Please try again.');
            });
  }

  function saveUrlNote() {
    const label = document.getElementById('url-label').value;
    const url = document.getElementById('url-url').value;
    const description = document.getElementById('url-description').value;

    if (!label || !url) {
      alert('Please fill in all required fields');
      return;
    }

    // Get the context path dynamically
    const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1)) || '';

    fetch(contextPath + '/api/notes', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        type: 'URL',
        label: label,
        url: url,
        description: description
      })
    })
            .then(response => {
              if (response.ok) {
                clearForm('url');
                loadNotes();
              } else {
                // Get more detailed error information
                response.text().then(errorText => {
                  console.error('Server responded with error:', response.status, errorText);
                  alert('Error saving note: ' + response.status + ' ' + errorText);
                });
              }
            })
            .catch(error => {
              console.error('Error:', error);
              alert('Error saving note. Please try again.');
            });
  }

  function saveImageNote() {
    const label = document.getElementById('image-label').value;
    const fileInput = document.getElementById('image-file');
    const caption = document.getElementById('image-caption').value;

    if (!label || !fileInput.files.length) {
      alert('Please fill in all required fields and select an image');
      return;
    }

    const file = fileInput.files[0];
    const reader = new FileReader();

    reader.onload = function(e) {
      const base64Data = e.target.result.split(',')[1];

      // Get the context path dynamically
      const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1)) || '';

      fetch(contextPath + '/api/notes', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          type: 'IMAGE',
          label: label,
          imageData: base64Data,
          imageFormat: file.type.split('/')[1],
          caption: caption
        })
      })
              .then(response => {
                if (response.ok) {
                  clearForm('image');
                  loadNotes();
                } else {
                  // Get more detailed error information
                  response.text().then(errorText => {
                    console.error('Server responded with error:', response.status, errorText);
                    alert('Error saving note: ' + response.status + ' ' + errorText);
                  });
                }
              })
              .catch(error => {
                console.error('Error:', error);
                alert('Error saving note. Please try again.');
              });
    };

    reader.readAsDataURL(file);
  }

  function clearForm(formType) {
    if (formType === 'text') {
      document.getElementById('text-label').value = '';
      document.getElementById('text-content').value = '';
    } else if (formType === 'url') {
      document.getElementById('url-label').value = '';
      document.getElementById('url-url').value = '';
      document.getElementById('url-description').value = '';
    } else if (formType === 'image') {
      document.getElementById('image-label').value = '';
      document.getElementById('image-file').value = '';
      document.getElementById('image-caption').value = '';
    }
  }

  function loadNotes() {
    // 获取上下文路径
    const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1)) || '';

    // 显示加载中的消息
    const noteIndex = document.getElementById('note-index');
    const noteDetail = document.getElementById('note-detail');
    noteIndex.innerHTML = '<p>Loading notes...</p>';

    fetch(contextPath + '/api/notes')
            .then(response => {
              if (!response.ok) {
                return response.text().then(text => {
                  throw new Error('Server responded with status ' + response.status + ': ' + text);
                });
              }
              return response.json();
            })
            .then(notes => {
              // 存储所有笔记在全局变量中，以便索引功能使用
              window.allNotes = notes;

              console.log("Loaded notes:", notes);

              // 如果没有笔记，显示提示消息
              if (!notes || notes.length === 0) {
                noteIndex.innerHTML = '<p>No notes found. Create your first note!</p>';
                return;
              }

              // 创建索引
              buildNoteIndex(notes);

              // 默认选中第一个笔记
              if (notes.length > 0) {
                displayNoteDetail(notes[0].id);
              }

              // 如果URL中有搜索参数，执行搜索
              const urlParams = new URLSearchParams(window.location.search);
              const searchParam = urlParams.get('search');
              if (searchParam) {
                document.getElementById('search').value = searchParam;
                searchNotes();
              }
            })
            .catch(error => {
              console.error('Error loading notes:', error);
              noteIndex.innerHTML = '<p style="color: red;">Error loading notes: ' + error.message + '</p>';
              noteDetail.innerHTML = '<p style="color: red;">Error loading notes. Please refresh the page to try again.</p>';
            });
  }

  function buildNoteIndex(notes, isSummaryView = false) {
    const noteIndex = document.getElementById('note-index');
    noteIndex.innerHTML = '';

    // 创建索引项
    notes.forEach(note => {
      const indexItem = document.createElement('div');
      indexItem.className = 'index-item';
      indexItem.dataset.id = note.id;

      // 为不同笔记类型设置不同图标
      const iconClass = note.noteType.toLowerCase();
      const iconText = note.noteType.charAt(0);

      let itemContent = `
      <div class="index-item-icon ${iconClass}">${iconText}</div>
      <div class="index-item-label">${escapeHtml(note.label)}</div>
    `;

      // 如果是摘要视图，添加内容摘要
      if (isSummaryView) {
        let summary = '';

        switch (note.noteType) {
          case 'Text':
            // 取内容的前50个字符作为摘要
            summary = note.content ? escapeHtml(note.content.substring(0, 50)) + (note.content.length > 50 ? '...' : '') : '';
            break;

          case 'URL':
            summary = note.url ? escapeHtml(note.url) : '';
            break;

          case 'Image':
            summary = note.caption ? escapeHtml(note.caption) : 'Image';
            break;

          case 'Combined':
            summary = 'Combined note with ' + (note.components ? note.components.length : 0) + ' components';
            break;
        }

        itemContent += `<div class="note-summary">${summary}</div>`;
      }
      indexItem.innerHTML = itemContent;

      // 添加点击事件
      indexItem.addEventListener('click', function() {
        // 移除其他项目的活动状态
        document.querySelectorAll('.index-item').forEach(item => {
          item.classList.remove('active');
        });

        // 添加当前项目的活动状态
        indexItem.classList.add('active');

        // 显示笔记详情
        displayNoteDetail(note.id);
      });

      noteIndex.appendChild(indexItem);
    });
  }
  function displayNoteDetail(noteId) {
    const note = window.allNotes.find(n => n.id === noteId);
    if (!note) return;

    const noteDetail = document.getElementById('note-detail');

    // 生成笔记详情的HTML（复用您原有的笔记卡片生成代码）
    let contentHtml = '';

    // 根据笔记类型创建不同的内容
    switch (note.noteType) {
      case 'Text':
        contentHtml = '<h3>' + escapeHtml(note.label) + '</h3>' +
                '<p>' + escapeHtml(note.content) + '</p>';
        break;

      case 'URL':
        contentHtml = '<h3>' + escapeHtml(note.label) + '</h3>' +
                '<a href="' + escapeHtml(note.url) + '" target="_blank">' + escapeHtml(note.url) + '</a>' +
                '<p>' + escapeHtml(note.description) + '</p>';
        break;

      case 'Image':
        contentHtml = '<h3>' + escapeHtml(note.label) + '</h3>' +
                '<img src="data:image/' + escapeHtml(note.imageFormat) + ';base64,' + note.imagePath + '" ' +
                'alt="' + escapeHtml(note.caption) + '" style="max-width: 100%;">' +
                '<p>' + escapeHtml(note.caption) + '</p>';
        break;

      case 'Combined':
        contentHtml = '<h3>' + escapeHtml(note.label) + '</h3>';
        contentHtml += '<div class="combined-content">';

        if (note.components && Array.isArray(note.components) && note.components.length > 0) {
          note.components.forEach((component, index) => {
            contentHtml += '<div class="component component-' + (component.type || "unknown").toLowerCase() + '">';
            contentHtml += '<div class="component-header">' + (component.type || "未知") + ' 组件</div>';
            contentHtml += '<div class="component-body">';

            switch(component.type) {
              case "Text":
                if (component.content) {
                  contentHtml += '<p>' + escapeHtml(component.content) + '</p>';
                } else {
                  contentHtml += '<p><em>空文本组件</em></p>';
                }
                break;

              case "URL":
                let url = component.url || "";
                if (url && !url.match(/^https?:\/\//)) {
                  url = "https://" + url;
                }

                if (url) {
                  contentHtml += '<a href="' + url + '" target="_blank">' +
                          escapeHtml(component.url) + '</a><br>';
                } else {
                  contentHtml += '<p><em>无URL数据</em></p>';
                }

                if (component.description) {
                  contentHtml += '<p>' + escapeHtml(component.description) + '</p>';
                }
                break;

              case "Image":
                const imageFormat = component.imageFormat || "jpeg";

                if (component.imagePath) {
                  contentHtml += '<img src="data:image/' + imageFormat + ';base64,' +
                          component.imagePath + '" alt="' +
                          (component.caption ? escapeHtml(component.caption) : '图片') +
                          '" style="max-width: 100%;">';
                } else {
                  contentHtml += '<p><em>无图片数据</em></p>';
                }

                if (component.caption) {
                  contentHtml += '<p class="caption">' + escapeHtml(component.caption) + '</p>';
                }
                break;

              default:
                contentHtml += '<p><em>未知组件类型</em></p>';
            }

            contentHtml += '</div>'; // End of component-body
            contentHtml += '</div>'; // End of component
          });
        } else {
          contentHtml += '<p><em>此组合笔记没有组件</em></p>';
        }

        contentHtml += '</div>'; // End of combined-content
        break;

      default:
        contentHtml = '<h3>' + escapeHtml(note.label) + '</h3>' +
                '<p>Unsupported note type: ' + escapeHtml(note.noteType) + '</p>';
    }

    // 添加删除按钮
    contentHtml += '<div class="note-actions">' +
            '<button class="btn" onclick="deleteNote(\'' + note.id + '\')">Delete</button>' +
            '</div>';
    contentHtml += '<div class="note-actions">' +
            '<button class="btn btn-edit" onclick="editNote(\'' + note.id + '\')">Edit</button> ' +
            '<button class="btn" onclick="renameNote(\'' + note.id + '\')">Rename</button> ' +
            '<button class="btn btn-delete" onclick="deleteNote(\'' + note.id + '\')">Delete</button>' +
            '</div>';

    noteDetail.innerHTML = contentHtml;
  }

  function deleteNote(noteId) {
    if (confirm('Are you sure you want to delete this note?')) {
      // Get the context path dynamically
      const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1)) || '';

      fetch(contextPath + '/api/notes/' + noteId, {
        method: 'DELETE'
      })
              .then(response => {
                if (response.ok) {
                  loadNotes();
                } else {
                  // Get more detailed error information
                  response.text().then(errorText => {
                    console.error('Server responded with error:', response.status, errorText);
                    alert('Error deleting note: ' + response.status + ' ' + errorText);
                  });
                }
              })
              .catch(error => {
                console.error('Error:', error);
                alert('Error deleting note. Please try again.');
              });
    }
  }

  function renameNote(noteId) {
    const note = window.allNotes.find(n => n.id === noteId);
    if (!note) return;

    const newLabel = prompt("Enter new name for this note:", note.label);

    if (newLabel === null) return; // 用户取消操作
    if (newLabel.trim() === "") {
      alert("Note name cannot be empty");
      return;
    }

    // 创建一个包含更新信息的对象
    const updateData = {
      id: note.id,
      label: newLabel
    };

    // 调用API更新笔记
    updateNoteData(updateData, () => {
      // 更新成功后，刷新笔记列表
      loadNotes();
    });
  }

  function editNote(noteId) {
    const note = window.allNotes.find(n => n.id === noteId);
    if (!note) return;

    const noteDetail = document.getElementById('note-detail');
    let formHtml = '';

    // 根据笔记类型生成不同的编辑表单
    switch (note.noteType) {
      case 'Text':
        // 文本笔记编辑表单
        break;

      case 'URL':
        // URL笔记编辑表单
        break;

      case 'Image':
        // 图片笔记编辑表单
        break;

      case 'Combined':
        // 组合笔记暂不支持直接编辑
        break;
    }

    noteDetail.innerHTML = formHtml;
  }

  // 1. 实现 updateNoteData 函数来修复重命名功能
  function updateNoteData(updateData, callback) {
    const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1)) || '';

    fetch(contextPath + '/api/notes/' + updateData.id, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(updateData)
    })
            .then(response => {
              if (!response.ok) {
                return response.text().then(text => {
                  throw new Error('Failed to update note: ' + text);
                });
              }
              return response.text();
            })
            .then(() => {
              if (callback) callback();
            })
            .catch(error => {
              console.error('Error updating note:', error);
              alert('Error updating note: ' + error.message);
            });
  }

  // 2. 完整实现 editNote 函数
  function editNote(noteId) {
    const note = window.allNotes.find(n => n.id === noteId);
    if (!note) return;

    const noteDetail = document.getElementById('note-detail');
    let formHtml = '';

    // 根据笔记类型生成不同的编辑表单
    switch (note.noteType) {
      case 'Text':
        formHtml = `
        <h3>Edit Text Note</h3>
        <div class="form-group">
          <label for="edit-text-content">Content</label>
          <textarea id="edit-text-content" class="form-control" rows="5">${escapeHtml(note.content)}</textarea>
        </div>
        <div class="note-actions">
          <button class="btn" onclick="saveTextEdit('${note.id}')">Save</button>
          <button class="btn" onclick="displayNoteDetail('${note.id}')">Cancel</button>
        </div>
      `;
        break;

      case 'URL':
        formHtml = `
        <h3>Edit URL Note</h3>
        <div class="form-group">
          <label for="edit-url-url">URL</label>
          <input type="url" id="edit-url-url" class="form-control" value="${escapeHtml(note.url)}">
        </div>
        <div class="form-group">
          <label for="edit-url-description">Description</label>
          <textarea id="edit-url-description" class="form-control" rows="3">${escapeHtml(note.description)}</textarea>
        </div>
        <div class="note-actions">
          <button class="btn" onclick="saveUrlEdit('${note.id}')">Save</button>
          <button class="btn" onclick="displayNoteDetail('${note.id}')">Cancel</button>
        </div>
      `;
        break;

      case 'Image':
        formHtml = `
        <h3>Edit Image Note</h3>
        <div class="form-group">
          <label for="edit-image-caption">Caption</label>
          <textarea id="edit-image-caption" class="form-control" rows="2">${escapeHtml(note.caption)}</textarea>
        </div>
        <div class="form-group">
          <label for="edit-image-file">Replace Image (optional)</label>
          <input type="file" id="edit-image-file" class="form-control" accept="image/*">
        </div>
        <div>
          <img src="data:image/${escapeHtml(note.imageFormat)};base64,${note.imagePath}"
               alt="${escapeHtml(note.caption)}" style="max-width: 100%; margin-bottom: 10px;">
        </div>
        <div class="note-actions">
          <button class="btn" onclick="saveImageEdit('${note.id}')">Save</button>
          <button class="btn" onclick="displayNoteDetail('${note.id}')">Cancel</button>
        </div>
      `;
        break;

      case 'Combined':
        formHtml = `
        <h3>Edit Combined Note</h3>
        <p>Editing combined notes is not supported directly. Please delete and recreate the note with your changes.</p>
        <div class="note-actions">
          <button class="btn" onclick="displayNoteDetail('${note.id}')">Back</button>
        </div>
      `;
        break;

      default:
        formHtml = `
        <h3>Edit Not Supported</h3>
        <p>Editing this note type is not supported.</p>
        <div class="note-actions">
          <button class="btn" onclick="displayNoteDetail('${note.id}')">Back</button>
        </div>
      `;
    }

    noteDetail.innerHTML = formHtml;
  }

  // 3. 实现保存编辑内容的函数
  function saveTextEdit(noteId) {
    const note = window.allNotes.find(n => n.id === noteId);
    if (!note) return;

    const content = document.getElementById('edit-text-content').value;

    if (!content.trim()) {
      alert("Content cannot be empty");
      return;
    }

    const updateData = {
      id: note.id,
      content: content
    };

    updateNoteData(updateData, () => {
      // 重新加载笔记列表并显示当前笔记
      loadNotes();
      // 更新成功后一小段延迟再显示详情，确保数据已加载
      setTimeout(() => {
        displayNoteDetail(noteId);
      }, 300);
    });
  }

  function saveUrlEdit(noteId) {
    const note = window.allNotes.find(n => n.id === noteId);
    if (!note) return;

    const url = document.getElementById('edit-url-url').value;
    const description = document.getElementById('edit-url-description').value;

    if (!url.trim()) {
      alert("URL cannot be empty");
      return;
    }

    const updateData = {
      id: note.id,
      url: url,
      description: description
    };

    updateNoteData(updateData, () => {
      loadNotes();
      setTimeout(() => {
        displayNoteDetail(noteId);
      }, 300);
    });
  }

  function saveImageEdit(noteId) {
    const note = window.allNotes.find(n => n.id === noteId);
    if (!note) return;

    const caption = document.getElementById('edit-image-caption').value;
    const fileInput = document.getElementById('edit-image-file');

    // 如果没有选择新图片，只更新标题
    if (!fileInput.files.length) {
      const updateData = {
        id: note.id,
        caption: caption
      };

      updateNoteData(updateData, () => {
        loadNotes();
        setTimeout(() => {
          displayNoteDetail(noteId);
        }, 300);
      });
      return;
    }

    // 如果选择了新图片，读取并更新
    const file = fileInput.files[0];
    const reader = new FileReader();

    reader.onload = function(e) {
      const base64Data = e.target.result.split(',')[1];

      const updateData = {
        id: note.id,
        caption: caption,
        imageData: base64Data,
        imageFormat: file.type.split('/')[1]
      };

      updateNoteData(updateData, () => {
        loadNotes();
        setTimeout(() => {
          displayNoteDetail(noteId);
        }, 300);
      });
    };

    reader.readAsDataURL(file);
  }

  // Function to add component to combined note
  function addComponent() {
    const type = document.getElementById('component-type').value;
    const componentsContainer = document.getElementById('combined-components');
    const componentId = 'component-' + Date.now(); // Generate unique ID

    let componentHtml = '';

    switch(type) {
      case 'TEXT':
        componentHtml = `
        <div class="component-item" data-id="${componentId}" data-type="TEXT">
          <div class="form-group">
            <label>Text Content</label>
            <textarea class="component-content" rows="3" placeholder="Enter text content"></textarea>
          </div>
          <button class="btn btn-delete" type="button" onclick="removeComponent('${componentId}')">Remove</button>
        </div>
      `;
        break;

      case 'URL':
        componentHtml = `
        <div class="component-item" data-id="${componentId}" data-type="URL">
          <div class="form-group">
            <label>URL</label>
            <input type="url" class="component-url" placeholder="https://example.com">
          </div>
          <div class="form-group">
            <label>Description</label>
            <textarea class="component-description" rows="2" placeholder="Describe this URL"></textarea>
          </div>
          <button class="btn btn-delete" type="button" onclick="removeComponent('${componentId}')">Remove</button>
        </div>
      `;
        break;

      case 'IMAGE':
        componentHtml = `
        <div class="component-item" data-id="${componentId}" data-type="IMAGE">
          <div class="form-group">
            <label>Image</label>
            <input type="file" class="component-image" accept="image/*">
          </div>
          <div class="form-group">
            <label>Caption</label>
            <textarea class="component-caption" rows="2" placeholder="Add a caption to your image"></textarea>
          </div>
          <button class="btn btn-delete" type="button" onclick="removeComponent('${componentId}')">Remove</button>
        </div>
      `;
        break;
    }

    // Create a container div for the component
    const componentContainer = document.createElement('div');
    componentContainer.className = 'component';
    componentContainer.innerHTML = componentHtml;

    // Add the component to the container
    componentsContainer.appendChild(componentContainer);
  }

  // Function to remove a component from combined note
  function removeComponent(id) {
    const component = document.querySelector(`.component-item[data-id="${id}"]`).closest('.component');
    if (component) {
      component.remove();
    }
  }

  // Function to save combined note
  function saveCombinedNote() {
    const label = document.getElementById('combined-label').value;
    const components = document.querySelectorAll('.component-item');

    if (!label || components.length === 0) {
      alert('Please add a label and at least one component');
      return;
    }

    const note = { type: 'COMBINED', label: label, components: [] };

    // Process components asynchronously
    const processComponents = async () => {
      for (const component of components) {
        const type = component.dataset.type;
        let componentData = { type: type };

        switch(type) {
          case 'TEXT':
            componentData.content = component.querySelector('.component-content').value;
            break;

          case 'URL':
            componentData.url = component.querySelector('.component-url').value;
            componentData.description = component.querySelector('.component-description').value;
            break;

          case 'IMAGE':
            const fileInput = component.querySelector('.component-image');
            if (fileInput.files.length) {
              const file = fileInput.files[0];
              const base64 = await readFileAsBase64(file);
              componentData.imageData = base64.split(',')[1];
              componentData.imageFormat = file.type.split('/')[1];
              componentData.caption = component.querySelector('.component-caption').value;
            }
            break;
        }

        note.components.push(componentData);
      }

      saveNote(note);
    };

    processComponents();
  }

  // Helper function to read a file as base64
  function readFileAsBase64(file) {
    return new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.onload = () => resolve(reader.result);
      reader.onerror = reject;
      reader.readAsDataURL(file);
    });
  }

  function addViewSwitcher() {
    // 添加视图切换下拉菜单
    const viewSwitcher = document.createElement('div');
    viewSwitcher.className = 'view-switcher';
    viewSwitcher.innerHTML = `
    <label for="view-mode">View Mode: </label>
    <select id="view-mode" onchange="changeViewMode()">
      <option value="default">Default View</option>
      <option value="created">By Creation Date</option>
      <option value="modified">By Modified Date</option>
      <option value="alphabetical">Alphabetical</option>
      <option value="summary">Summary View</option>
    </select>
  `;

    // 添加到搜索容器后
    document.querySelector('.search-container').appendChild(viewSwitcher);
  }

  function debugCombinedNotes() {
    // 获取上下文路径
    const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1)) || '';

    // 获取所有笔记
    fetch(contextPath + '/api/notes')
            .then(response => response.json())
            .then(notes => {
              // 查找组合笔记
              const combinedNotes = notes.filter(note => note.noteType === "Combined");
              console.log("组合笔记数量:", combinedNotes.length);

              if (combinedNotes.length > 0) {
                console.log("第一个组合笔记:", combinedNotes[0]);

                // 提取和显示组件
                const components = combinedNotes[0].components;
                if (components && components.length > 0) {
                  console.log("组件数量:", components.length);
                  components.forEach((comp, i) => {
                    console.log(`组件 ${i+1} 类型: ${comp.type}`);
                  });
                } else {
                  console.log("没有找到组件或组件不是数组");
                  console.log("组件值:", components);
                }
              }
            })
            .catch(error => console.error("获取笔记时出错:", error));
  }

  function inspectCombinedNote(noteId) {
    const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1)) || '';

    fetch(contextPath + '/api/notes')
            .then(response => response.json())
            .then(notes => {
              const note = notes.find(n => n.id === noteId);
              if (note) {
                console.log("查找到笔记:", note);

                if (note.components) {
                  console.log("组件数量:", note.components.length);
                  note.components.forEach((comp, i) => {
                    console.log(`组件 ${i+1}:`, comp);

                    // 针对图片组件进行特别检查
                    if (comp.type === "Image") {
                      console.log(`  图片格式: ${comp.imageFormat || "未指定"}`);
                      console.log(`  图片数据长度: ${comp.imagePath ? comp.imagePath.length : 0} 字符`);
                    }

                    // 针对URL组件进行特别检查
                    if (comp.type === "URL") {
                      console.log(`  URL: ${comp.url || "未指定"}`);
                      console.log(`  描述: ${comp.description || "未指定"}`);
                    }
                  });
                } else {
                  console.log("未找到组件数组");
                }
              } else {
                console.log("未找到指定ID的笔记");
              }
            })
            .catch(error => console.error("获取笔记出错:", error));
  }

  // 使用方法：inspectCombinedNote("您的组合笔记ID");

  function searchNotes() {
    const searchTerm = document.getElementById('search').value.toLowerCase().trim();
    console.log("Searching for:", searchTerm);

    if (!window.allNotes) return;

    const noteIndex = document.getElementById('note-index');
    const indexItems = noteIndex.querySelectorAll('.index-item');

    let visibleCount = 0;

    if (!searchTerm) {
      // 如果搜索词为空，显示所有笔记
      indexItems.forEach(item => {
        item.style.display = 'flex';
        visibleCount++;
      });

      console.log(`Showing all ${visibleCount} notes`);
      return;
    }

    // 在索引中搜索
    indexItems.forEach(item => {
      const noteId = item.dataset.id;
      const note = window.allNotes.find(n => n.id === noteId);

      if (!note) {
        item.style.display = 'none';
        return;
      }

      // 搜索标题和内容
      let match = false;

      // 检查标题
      if (note.label.toLowerCase().includes(searchTerm)) {
        match = true;
      }

      // 检查内容
      if (!match) {
        switch (note.noteType) {
          case 'Text':
            if (note.content && note.content.toLowerCase().includes(searchTerm)) {
              match = true;
            }
            break;
          case 'URL':
            if ((note.url && note.url.toLowerCase().includes(searchTerm)) ||
                    (note.description && note.description.toLowerCase().includes(searchTerm))) {
              match = true;
            }
            break;
          case 'Image':
            if (note.caption && note.caption.toLowerCase().includes(searchTerm)) {
              match = true;
            }
            break;
          case 'Combined':
            if (note.components && Array.isArray(note.components)) {
              note.components.forEach(component => {
                if (component.type === "Text" && component.content &&
                        component.content.toLowerCase().includes(searchTerm)) {
                  match = true;
                } else if (component.type === "URL" &&
                        ((component.url && component.url.toLowerCase().includes(searchTerm)) ||
                                (component.description && component.description.toLowerCase().includes(searchTerm)))) {
                  match = true;
                } else if (component.type === "Image" && component.caption &&
                        component.caption.toLowerCase().includes(searchTerm)) {
                  match = true;
                }
              });
            }
            break;
        }
      }

// 显示或隐藏索引项
      item.style.display = match ? 'flex' : 'none';

      if (match) {
        visibleCount++;
        // 如果是第一个匹配项，选中它并显示详情
        if (visibleCount === 1) {
          item.click();
        }
      }
    });

    console.log(`Search complete. Found ${visibleCount} notes matching "${searchTerm}"`);

// 处理没有结果的情况
    if (visibleCount === 0) {
      const noteDetail = document.getElementById('note-detail');
      noteDetail.innerHTML = `<p>No notes found matching "${searchTerm}"</p>`;
    }
  }



</script>
</body>
</html>
