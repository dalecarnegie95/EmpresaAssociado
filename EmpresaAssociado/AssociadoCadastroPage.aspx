<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AssociadoCadastroPage.aspx.cs" Inherits="EmpresaAssociado.AssociadoCadastroPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Cadastro de Associados</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" crossorigin="anonymous">
</head>
<body>
    <form id="form1" runat="server">
        
        <div class="container mt-4">        
            <asp:Button ID="btnMudaPagina" class="btn btn-info" runat="server" Text="Empresas" OnClick="btnAlteraPagina_Click" />
            <h2>Cadastro de Associados</h2>

            <!-- Conteúdo do formulário de pesquisa de empreasas -->
            <div class="form-row">
                <div class="form-group col-md-3">
                    <label for="txtPesquisaNomeAssociado">Nome:</label>
                    <asp:TextBox ID="txtPesquisaNomeAssociado" runat="server" CssClass="form-control" />
                </div>
                <div class="form-group col-md-3">
                    <label for="txtPesquisaCPFAssociado">CPF:</label>
                    <asp:TextBox ID="txtPesquisaCPFAssociado" runat="server" CssClass="form-control" />
                </div>  
                <div class="form-group col-md-3">
                    <label for="txtPesquisaDataNascimento">Data de Nascimento:</label>
                    <asp:TextBox ID="txtPesquisaDataNascimento" runat="server" CssClass="form-control"  placeholder="DD/MM/AAAA" MaxLength="10" />
                </div> 
                
            </div>
            
            <button type="button" class="btn btn-info" onclick="pesquisarAssociados()">Pesquisar Associado</button>
            <button type="button" class="btn btn-primary " data-toggle="modal" onclick="adicionarNovaAssociado(this)">Adicionar Associado</button>

            <!-- Tabela de Associados -->
            <table class="table" style="margin-top: 15px;">
                <thead>
                    <tr>
                        <th>Id</th>
                        <th>Nome</th>
                        <th>CPF</th>
                        <th>Data de Nascimento</th>
                        <th>Ação</th>
                    </tr>
                </thead>
                <tbody id="associadosTableBody" runat="server">
                    <!-- Linhas da tabela serão adicionadas aqui dinamicamente -->
                </tbody>
            </table>
        </div>

        <!-- Modal de Adicionar/Editar Associado -->
        <div class="modal fade" id="modalAdicionarAssociado" tabindex="-1" role="dialog" aria-labelledby="modalAdicionarAssociadoLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalAdicionarAssociadoLabel">Adicionar/Editar Associado</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <!-- Campos da Associado -->
                        <div class="form-group">
                            <label for="txtNomeAssociadoModal">Nome da Associado:</label>
                            <input type="text" id="txtNomeAssociadoModal" class="form-control" />
                            <input type="hidden" id="txtIdAssociadoModal" />
                        </div>
                        <div class="form-group">
                            <label for="txtCpfAssociadoModal">CPF:</label>
                            <input type="text" id="txtCpfAssociadoModal" class="form-control" />
                        </div>
                        <div class="form-group">
                            <label for="txtDataNascimentoAssociadoModal">Data de Nascimento:</label>
                            <input type="text" id="txtDataNascimentoAssociadoModal" class="form-control" placeholder="DD/MM/AAAA" MaxLength="10" />
                        </div>

                        <!-- Tabela de Empresas -->
                        <h4>Empresas</h4>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Id</th>
                                    <th>Nome</th>
                                    <th>CNPJ</th>                                    
                                    <th>Ação</th>
                                </tr>
                            </thead>
                            <tbody id="empresasAssociadoTableBody">
                                <!-- Linhas da tabela de empresas serão adicionadas aqui dinamicamente -->
                            </tbody>
                        </table>

                        <!-- Botão para Adicionar Empresa -->
                        <button type="button" class="btn btn-success" onclick="abrirPopupPesquisaEmpresas()">Adicionar Empresa</button>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Fechar</button>
                        <button type="button" class="btn btn-primary" onclick="salvarAssociado()">Salvar Associado</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal de Pesquisa de Empresas -->
        <div class="modal fade" id="modalPesquisaEmpresas" tabindex="-2" role="dialog" aria-labelledby="modalPesquisaEmpresasLabel" aria-hidden="true">
            <div class="modal-dialog modal-xl" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalPesquisaEmpresasLabel">Pesquisa de Empresas</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <!-- Conteúdo do formulário de pesquisa de empresas -->
                        <div class="form-row">
                            <div class="form-group col-md-4">
                                <label for="txtPesquisaNome">Nome:</label>
                                <asp:TextBox ID="txtPesquisaNome" runat="server" CssClass="form-control" />
                            </div>
                            <div class="form-group col-md-4">
                                <label for="txtPesquisaCNPJ">CNPJ:</label>
                                <asp:TextBox ID="txtPesquisaCNPJ" runat="server" CssClass="form-control" />
                            </div>                           
                        </div>
                        <button type="button" class="btn btn-info" onclick="pesquisarEmpresas()">Pesquisar Empresas</button>
                        <div id="resultadoPesquisaEmpresasModal" runat="server">
                            <!-- Resultados da pesquisa de empresas serão adicionados aqui -->
                        </div>

                        <!-- Tabela de Empresas -->
                        <h4>Empresas</h4>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Id</th>
                                    <th>Nome</th>
                                    <th>CNPJ</th>                                    
                                    <th>Ação</th>
                                </tr>
                            </thead>
                            <tbody id="empresasAssociadoPesquisaTableBody">
                                <!-- Linhas da tabela de empresas serão adicionadas aqui dinamicamente -->
                            </tbody>
                        </table>



                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Fechar</button>
                    </div>
                </div>
            </div>
        </div>


        <script src="https://code.jquery.com/jquery-3.3.1.min.js" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.inputmask/5.0.6/jquery.inputmask.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js" crossorigin="anonymous"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" crossorigin="anonymous"></script>
        <script>
            
            function pesquisarAssociados() {
                getAssociados();
            }
            function pesquisarEmpresas() {
               
                let nome = $('#txtPesquisaNome').val();
                let cnpj = $('#txtPesquisaCNPJ').val();                

                const parametros = `?nome=${encodeURIComponent(nome)}&cnpj=${encodeURIComponent(cnpj)}`;

                const url = `api/Empresa${parametros}`;

                let resultados = "";
                $.ajax({
                    type: "GET",
                    url: url,
                    contentType: "application/json; charset=utf-8",
                    success: function (response) {
                        exibirResultadosPesquisa(response);
                    },
                    error: function (error) {
                        alert(JSON.parse(error.responseText).Message)
                    }
                });
            }

            function adicionaEmpresaNaAssociado(botaoAdicionar) {
                var linha = botaoAdicionar.parentNode.parentNode;

                var idEmpresa = linha.cells[0].innerText;
                var nome = linha.cells[1].innerText;
                var cnpj = linha.cells[2].innerText;
                

                let novoEmpresa = {
                    Id: idEmpresa,
                    Nome: nome,
                    CNPJ: cnpj                    
                };

                empresas.push(novoEmpresa);

                if (IdsEmpresasAdicionar.indexOf(idEmpresa) === -1) {
                    // Se não existir, adiciona o número ao array                   
                    IdsEmpresasAdicionar.push(idEmpresa);
                }
                preencherTabelaEmpresasModal(empresas);
            }

            function exibirResultadosPesquisa(empresas) {

                var empresasTableBody = document.getElementById("empresasAssociadoPesquisaTableBody");
                empresasTableBody.innerHTML = "";

                empresas.forEach(function (empresa) {
                    var novaLinha = empresasTableBody.insertRow();
                    var colunaId = novaLinha.insertCell(0);
                    var colunaNome = novaLinha.insertCell(1);
                    var colunaCnpj = novaLinha.insertCell(2);                    
                    var colunaAcao = novaLinha.insertCell(3);

                    colunaId.innerHTML = empresa.Id;
                    colunaNome.innerHTML = empresa.Nome;
                    colunaCnpj.innerHTML = adicionarMascaraCNPJ(empresa.CNPJ);                    
                    colunaAcao.innerHTML = '<button type="button" class="btn btn-success" onclick="adicionaEmpresaNaAssociado(this)">Adicionar</button>';
                });
            }

            function abrirPopupPesquisaEmpresas() {
                var associadosTableBody = document.getElementById("empresasAssociadoPesquisaTableBody");
                associadosTableBody.innerHTML = '';
                $('#modalPesquisaEmpresas').modal('show');
            }

            function adicionarEmpresaModal() {
                // Lógica para adicionar uma nova linha na tabela de empresas no modal
                var empresaTableBody = document.getElementById("empresasAssociadoTableBody");
                var novaLinha = empresaTableBody.insertRow();
                var colunaId = novaLinha.insertCell(0);
                var colunaNome = novaLinha.insertCell(1);
                var colunaCpf = novaLinha.insertCell(2);
                var colunaDataNascimento = novaLinha.insertCell(3);
                var colunaAcao = novaLinha.insertCell(4);

                colunaId.innerHTML = '<input type="text" class="form-control" />';
                colunaNome.innerHTML = '<input type="text" class="form-control" />';
                colunaCpf.innerHTML = '<input type="text" class="form-control" />';
                colunaDataNascimento.innerHTML = '<input type="text" class="form-control" />';
                colunaAcao.innerHTML = '<button type="button" class="btn btn-danger" onclick="removerEmpresaModal(this)">Remover</button>';
            }

            function removerEmpresaModal(botaoRemover) {
                // Lógica para remover a linha da tabela de empresas no modal
                var linha = botaoRemover.parentNode.parentNode;
                var idEmpresa = linha.cells[0].innerText;
                
                if (IdsEmpresasRemover.indexOf(idEmpresa) === -1) {
                    // Se não existir, adiciona o número ao array                   
                    IdsEmpresasRemover.push(idEmpresa);
                }

                linha.parentNode.removeChild(linha);
            }

            function salvarAssociado() {             

                var idAssociado = $('#txtIdAssociadoModal').val();
                if (idAssociado === "0") {
                    //adição de associado

                    var dadosJson = {
                        "Nome": $('#txtNomeAssociadoModal').val(),
                        "Cpf": $('#txtCpfAssociadoModal').inputmask('unmaskedvalue'),                        
                        "DataNascimento": $('#txtDataNascimentoAssociadoModal').val(), 
                        "IdsEmpresasAdicionar": IdsEmpresasAdicionar
                    };

                    $.ajax({
                        type: "POST", 
                        url: "api/Associado",
                        contentType: "application/json; charset=utf-8",
                        data: JSON.stringify(dadosJson),
                        dataType: "json",
                        success: function (response) {
                            alert("Dados do associado e empresas foram salvos.");
                            // Fechar o modal
                            $('#modalAdicionarAssociado').modal('hide');
                            getAssociados();
                        },
                        error: function (error) {
                            alert(JSON.parse(error.responseText).Message)
                        }
                    });
                } else {
                    //edição de associado
                    var dadosJson = {
                        "Id": $('#txtIdAssociadoModal').val(),
                        "Nome": $('#txtNomeAssociadoModal').val(),
                        "Cpf": $('#txtCpfAssociadoModal').inputmask('unmaskedvalue'),
                        "DataNascimento": $('#txtDataNascimentoAssociadoModal').val(), 
                        "IdsEmpresasAdicionar": IdsEmpresasAdicionar,
                        "IdsEmpresasRemover": IdsEmpresasRemover
                    };

                    $.ajax({
                        type: "PUT", 
                        url: "api/Associado",
                        contentType: "application/json; charset=utf-8",
                        data: JSON.stringify(dadosJson),
                        dataType: "json",
                        success: function (response) {
                            alert("Dados do associado e empresas foram salvos.");
                            // Fechar o modal
                            $('#modalAdicionarAssociado').modal('hide');
                            getAssociados();
                        },
                        error: function (error) {
                            alert(JSON.parse(error.responseText).Message)
                        }
                    });
                }
            }
         
            $(document).ready(function () {                
                $('#txtPesquisaCPFAssociado').inputmask('99.999.999/9999-99', { clearMaskOnLostFocus: false });
                $('#txtPesquisaDataNascimento').inputmask('99/99/9999');
                $('#txtDataNascimentoAssociadoModal').inputmask('99/99/9999');
                //$('#txtCpfAssociadoModal').inputmask('99.999.999/9999-99', { clearMaskOnLostFocus: false });
                $('#txtCpfAssociadoModal').inputmask('999.999.999-99', { clearMaskOnLostFocus: false });
                $('#txtPesquisaCpf').inputmask('999.999.999-99', { clearMaskOnLostFocus: false });
                
                
                
                
                getAssociados();
            });

            function adicionarAssociado(id, nome, cpf, dataNascimento,  empresas) {                
                var associadosTableBody = document.getElementById("associadosTableBody");

                var novaLinha = associadosTableBody.insertRow();
                var colunaId = novaLinha.insertCell(0);
                var colunaNome = novaLinha.insertCell(1);
                var colunaCpf = novaLinha.insertCell(2);
                var colunaDataNascimento = novaLinha.insertCell(3);
                var colunaAcao = novaLinha.insertCell(4);

                colunaId.innerHTML = id;
                colunaNome.innerHTML = nome;
                colunaCpf.innerHTML = adicionarMascaraCPF(cpf);
                colunaDataNascimento.innerHTML = adicionarMascaraDataNascimento(dataNascimento);
                colunaAcao.innerHTML = '<button type="button" class="btn btn-danger" onclick="excluirAssociado(this)">Excluir</button>' +
                    '<button type="button" class="btn btn-warning ml-2" onclick="editarAssociado(this)">Editar</button>';
            }

            function adicionarMascaraCNPJ(texto) {
                // Remover caracteres não numéricos do texto
                var apenasNumeros = texto.replace(/\D/g, '');

                // Adicionar a máscara de CNPJ
                var cnpjFormatado = apenasNumeros.replace(/^(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})$/, '$1.$2.$3/$4-$5');

                return cnpjFormatado;
            }

            function adicionarMascaraCPF(cpf) {
                // Remove todos os caracteres não numéricos
                cpf = cpf.replace(/\D/g, '');

                // Aplica a máscara (XXX.XXX.XXX-XX)
                cpf = cpf.replace(/(\d{3})(\d{3})(\d{3})(\d{2})/, '$1.$2.$3-$4');

                return cpf;
            }

            function adicionarMascaraDataNascimento(data) {
                // Extrai o ano, mês e dia da string de entrada
                const ano = data.substring(0, 4);
                const mes = data.substring(5, 7);
                const dia = data.substring(8, 10);

                // Cria a data formatada com a máscara (DD/MM/AAAA)
                const dataFormatada = `${dia}/${mes}/${ano}`;

                return dataFormatada;
            }

            function excluirAssociado(botaoExcluir) {

                var linha = botaoExcluir.parentNode.parentNode;
                var idAssociado = linha.cells[0].innerText;

                $.ajax({
                    type: "DELETE",
                    url: "api/Associado/" + idAssociado,
                    contentType: "application/json; charset=utf-8",
                    success: function (response) {
                        alert("Associado Excluída");
                        linha.parentNode.removeChild(linha);
                    },
                    error: function (error) {
                        alert(JSON.parse(error.responseText).Message)
                    }
                });
            }

            let IdsEmpresasRemover = new Array();
            let IdsEmpresasAdicionar = new Array();
            var empresas = "";
            function editarAssociado(botaoEditar) {
                empresas = "";
                IdsEmpresasRemover = new Array();
                IdsEmpresasAdicionar = new Array();

                // Lógica para preencher o modal de edição com os dados da associado selecionada
                var linha = botaoEditar.parentNode.parentNode;

                var idAssociado = linha.cells[0].innerText;
                var nomeAssociado = linha.cells[1].innerText;
                var cpfaAsociado = linha.cells[2].innerText;
                var dataNascimentoAssociado = linha.cells[3].innerText;
                
                // Preencha os campos do modal de edição com os dados da associado
                document.getElementById("txtNomeAssociadoModal").value = nomeAssociado;
                document.getElementById("txtCpfAssociadoModal").value = cpfaAsociado;
                document.getElementById("txtDataNascimentoAssociadoModal").value = dataNascimentoAssociado;
                document.getElementById("txtIdAssociadoModal").value = idAssociado;


                // Lógica para preencher a tabela de empresas no modal
                $.getJSON("api/Associado/" + idAssociado,
                    function (data) {    
                        empresas = data.Empresas;                              
                        preencherTabelaEmpresasModal(empresas);
                    });


                // Abre o modal de edição
                $('#modalAdicionarAssociado').modal('show');
            }

            function adicionarNovaAssociado(botaoAdicionar) {
                empresas = "";
                IdsEmpresasRemover = new Array();
                IdsEmpresasAdicionar = new Array();

                // Preencha os campos do modal de edição com os dados da associado
                document.getElementById("txtNomeAssociadoModal").value = "";
                document.getElementById("txtCpfAssociadoModal").value = "";
                document.getElementById("txtDataNascimentoAssociadoModal").value = "";
                document.getElementById("txtIdAssociadoModal").value = "0";

                var empresasTableBody = document.getElementById("empresasAssociadoTableBody");
                empresasTableBody.innerHTML = "";

                empresas = JSON.parse("[]");

                // Abre o modal de edição
                $('#modalAdicionarAssociado').modal('show');
            }

            function preencherTabelaEmpresasModal(empresas) {
                var empresasTableBody = document.getElementById("empresasAssociadoTableBody");
                empresasTableBody.innerHTML = "";

                empresas.forEach(function (empresa) {
                    var novaLinha = empresasTableBody.insertRow();
                    var colunaId = novaLinha.insertCell(0);
                    var colunaNome = novaLinha.insertCell(1);
                    var colunaCnpj = novaLinha.insertCell(2);                    
                    var colunaAcao = novaLinha.insertCell(3);

                    colunaId.innerHTML = empresa.Id;
                    colunaNome.innerHTML = empresa.Nome;
                    colunaCnpj.innerHTML = adicionarMascaraCNPJ(empresa.CNPJ);                    
                    colunaAcao.innerHTML = '<button type="button" class="btn btn-danger" onclick="removerEmpresaModal(this)">Remover</button>';
                });
            }

            function getAssociados() {

                let nome = $('#txtPesquisaNomeAssociado').val();
                let cpf = $('#txtPesquisaCPFAssociado').inputmask('unmaskedvalue');
                let dataNascimento = $('#txtPesquisaDataNascimento').val();
                
                if (nome !== "" || cpf !== "" || dataNascimento !== "") {  
                    getAssociadosNomeCPFDataNascimento(nome, cpf, dataNascimento);
                } else {
                    $.getJSON("api/Associado",
                        function (data) {
                            var associadosTableBody = document.getElementById("associadosTableBody");
                            associadosTableBody.innerHTML = '';
                      
                            $.each(data, function (key, val) {
                                adicionarAssociado(val.Id, val.Nome, val.Cpf, val.DataNascimento, val.Empresas);
                            });
                        });
                }               
            }

            function getAssociadosNomeCPFDataNascimento(nome, cpf, dataNascimento) {
                const parametros = `?nome=${encodeURIComponent(nome)}&cpf=${encodeURIComponent(cpf)}&datanascimento=${encodeURIComponent(dataNascimento)}`;
          
                const url = `api/Associado${parametros}`;

                $.getJSON(url,
                    function (data) {
                        var associadosTableBody = document.getElementById("associadosTableBody");
                        associadosTableBody.innerHTML = '';
                        
                        $.each(data, function (key, val) {
                            adicionarAssociado(val.Id, val.Nome, val.Cpf, val.DataNascimento, val.Empresas);
                        });
                    });
            }

        </script>
    </form>
</body>
</html>
