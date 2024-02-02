<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmpresaCadastroPage.aspx.cs" Inherits="EmpresaAssociado.EmpresaCadastroPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Cadastro de Empresas</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" crossorigin="anonymous">
</head>
<body>
    <form id="form1" runat="server">
        
        <div class="container mt-4">        
            <asp:Button ID="btnMudaPagina" class="btn btn-info" runat="server" Text="Associados" OnClick="btnAlteraPagina_Click" />
            <h2>Cadastro de Empresas</h2>

            <!-- Conteúdo do formulário de pesquisa de empreasas -->
            <div class="form-row">
                <div class="form-group col-md-3">
                    <label for="txtPesquisaNomeEmpresa">Nome:</label>
                    <asp:TextBox ID="txtPesquisaNomeEmpresa" runat="server" CssClass="form-control" />
                </div>
                <div class="form-group col-md-3">
                    <label for="txtPesquisaCNPJ">CNPJ:</label>
                    <asp:TextBox ID="txtPesquisaCNPJ" runat="server" CssClass="form-control" />
                </div>  
                
            </div>
            
            <button type="button" class="btn btn-info" onclick="pesquisarEmpresas()">Pesquisar Empresa</button>
            <button type="button" class="btn btn-primary " data-toggle="modal" onclick="adicionarNovaEmpresa(this)">Adicionar Empresa</button>

            <!-- Tabela de Empresas -->
            <table class="table" style="margin-top: 15px;">
                <thead>
                    <tr>
                        <th>Id</th>
                        <th>Nome</th>
                        <th>CNPJ</th>
                        <th>Ação</th>
                    </tr>
                </thead>
                <tbody id="empresasTableBody" runat="server">
                    <!-- Linhas da tabela serão adicionadas aqui dinamicamente -->
                </tbody>
            </table>
        </div>

        <!-- Modal de Adicionar/Editar Empresa -->
        <div class="modal fade" id="modalAdicionarEmpresa" tabindex="-1" role="dialog" aria-labelledby="modalAdicionarEmpresaLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalAdicionarEmpresaLabel">Adicionar/Editar Empresa</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <!-- Campos da Empresa -->
                        <div class="form-group">
                            <label for="txtNomeEmpresaModal">Nome da Empresa:</label>
                            <input type="text" id="txtNomeEmpresaModal" class="form-control" />
                            <input type="hidden" id="txtIdEmpresaModal" />
                        </div>
                        <div class="form-group">
                            <label for="txtCnpjEmpresaModal">CNPJ:</label>
                            <input type="text" id="txtCnpjEmpresaModal" class="form-control" />
                        </div>

                        <!-- Tabela de Associados -->
                        <h4>Associados</h4>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Id</th>
                                    <th>Nome</th>
                                    <th>CPF</th>
                                    <th>Data de Nascimento</th>
                                    <th>Ação</th>
                                </tr>
                            </thead>
                            <tbody id="associadosEmpresaTableBody">
                                <!-- Linhas da tabela de associados serão adicionadas aqui dinamicamente -->
                            </tbody>
                        </table>

                        <!-- Botão para Adicionar Associado -->
                        <button type="button" class="btn btn-success" onclick="abrirPopupPesquisaAssociados()">Adicionar Associado</button>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Fechar</button>
                        <button type="button" class="btn btn-primary" onclick="salvarEmpresa()">Salvar Empresa</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal de Pesquisa de Associados -->
        <div class="modal fade" id="modalPesquisaAssociados" tabindex="-2" role="dialog" aria-labelledby="modalPesquisaAssociadosLabel" aria-hidden="true">
            <div class="modal-dialog modal-xl" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalPesquisaAssociadosLabel">Pesquisa de Associados</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <!-- Conteúdo do formulário de pesquisa de associados -->
                        <div class="form-row">
                            <div class="form-group col-md-4">
                                <label for="txtPesquisaNome">Nome:</label>
                                <asp:TextBox ID="txtPesquisaNome" runat="server" CssClass="form-control" />
                            </div>
                            <div class="form-group col-md-4">
                                <label for="txtPesquisaCpf">CPF:</label>
                                <asp:TextBox ID="txtPesquisaCpf" runat="server" CssClass="form-control" />
                            </div>
                            <div class="form-group col-md-4">
                                <label for="txtPesquisaDataNascimento">Data de Nascimento:</label>
                                <asp:TextBox ID="txtPesquisaDataNascimento" runat="server" CssClass="form-control" placeholder="DD/MM/AAAA" maxlength="10" />
                            </div>
                        </div>
                        <button type="button" class="btn btn-info" onclick="pesquisarAssociados()">Pesquisar Associados</button>
                        <div id="resultadoPesquisaAssociadosModal" runat="server">
                            <!-- Resultados da pesquisa de associados serão adicionados aqui -->
                        </div>

                        <!-- Tabela de Associados -->
                        <h4>Associados</h4>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Id</th>
                                    <th>Nome</th>
                                    <th>CPF</th>
                                    <th>Data de Nascimento</th>
                                    <th>Ação</th>
                                </tr>
                            </thead>
                            <tbody id="associadosEmpresaPesquisaTableBody">
                                <!-- Linhas da tabela de associados serão adicionadas aqui dinamicamente -->
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
            
            function pesquisarEmpresas() {
                getEmpresas();
            }
            function pesquisarAssociados() {
                
                let nome = $('#txtPesquisaNome').val();
                let cpf = $('#txtPesquisaCpf').val();
                let dataNascimento = $('#txtPesquisaDataNascimento').val();

                const parametros = `?nome=${encodeURIComponent(nome)}&cpf=${encodeURIComponent(cpf)}&dataNascimento=${encodeURIComponent(dataNascimento)}`;

                const url = `api/Associado${parametros}`;

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

            function adicionaAssociadoNaEmpresa(botaoAdicionar) {
                var linha = botaoAdicionar.parentNode.parentNode;

                var idAssociado = linha.cells[0].innerText;
                var nome = linha.cells[1].innerText;
                var cpf = linha.cells[2].innerText;
                var dataNascimento = linha.cells[3].innerText;

                let novoAssociado = {
                    Id: idAssociado,
                    Nome: nome,
                    Cpf: cpf,
                    DataNascimento: dataNascimento
                };

                associados.push(novoAssociado);

                if (IdsAssociadosAdicionar.indexOf(idAssociado) === -1) {
                    // Se não existir, adiciona o número ao array                   
                    IdsAssociadosAdicionar.push(idAssociado);
                }
                preencherTabelaAssociadosModal(associados);
            }

            function exibirResultadosPesquisa(associados) {

                var associadosTableBody = document.getElementById("associadosEmpresaPesquisaTableBody");
                associadosTableBody.innerHTML = "";

                associados.forEach(function (associado) {
                    var novaLinha = associadosTableBody.insertRow();
                    var colunaId = novaLinha.insertCell(0);
                    var colunaNome = novaLinha.insertCell(1);
                    var colunaCpf = novaLinha.insertCell(2);
                    var colunaDataNascimento = novaLinha.insertCell(3);
                    var colunaAcao = novaLinha.insertCell(4);

                    colunaId.innerHTML = associado.Id;
                    colunaNome.innerHTML = associado.Nome;
                    colunaCpf.innerHTML = adicionarMascaraCPF(associado.Cpf);
                    colunaDataNascimento.innerHTML = adicionarMascaraDataNascimento(associado.DataNascimento);
                    colunaAcao.innerHTML = '<button type="button" class="btn btn-success" onclick="adicionaAssociadoNaEmpresa(this)">Adicionar</button>';
                });
            }

            function abrirPopupPesquisaAssociados() {
                var empresasTableBody = document.getElementById("associadosEmpresaPesquisaTableBody");
                empresasTableBody.innerHTML = '';
                $('#modalPesquisaAssociados').modal('show');
            }

            function adicionarAssociadoModal() {
                // Lógica para adicionar uma nova linha na tabela de associados no modal
                var associadoTableBody = document.getElementById("associadosEmpresaTableBody");
                var novaLinha = associadoTableBody.insertRow();
                var colunaId = novaLinha.insertCell(0);
                var colunaNome = novaLinha.insertCell(1);
                var colunaCpf = novaLinha.insertCell(2);
                var colunaDataNascimento = novaLinha.insertCell(3);
                var colunaAcao = novaLinha.insertCell(4);

                colunaId.innerHTML = '<input type="text" class="form-control" />';
                colunaNome.innerHTML = '<input type="text" class="form-control" />';
                colunaCpf.innerHTML = '<input type="text" class="form-control" />';
                colunaDataNascimento.innerHTML = '<input type="text" class="form-control" />';
                colunaAcao.innerHTML = '<button type="button" class="btn btn-danger" onclick="removerAssociadoModal(this)">Remover</button>';
            }

            function removerAssociadoModal(botaoRemover) {
                // Lógica para remover a linha da tabela de associados no modal
                var linha = botaoRemover.parentNode.parentNode;
                var idAssociado = linha.cells[0].innerText;

                if (IdsAssociadosRemover.indexOf(idAssociado) === -1) {
                    // Se não existir, adiciona o número ao array                   
                    IdsAssociadosRemover.push(idAssociado);
                }

                linha.parentNode.removeChild(linha);
            }

            function salvarEmpresa() {             

                var idEmpresa = $('#txtIdEmpresaModal').val();
                if (idEmpresa === "0") {
                    //adição de empresa

                    var dadosJson = {
                        "Nome": $('#txtNomeEmpresaModal').val(),
                        "CNPJ": $('#txtCnpjEmpresaModal').inputmask('unmaskedvalue'),                        
                        "IdsAssociadosAdicionar": IdsAssociadosAdicionar
                    };

                    $.ajax({
                        type: "POST", 
                        url: "api/Empresa",
                        contentType: "application/json; charset=utf-8",
                        data: JSON.stringify(dadosJson),
                        dataType: "json",
                        success: function (response) {
                            alert("Dados da empresa e associados foram salvos.");
                            // Fechar o modal
                            $('#modalAdicionarEmpresa').modal('hide');
                            getEmpresas();
                        },
                        error: function (error) {
                            alert(JSON.parse(error.responseText).Message)
                        }
                    });
                } else {
                    //edição de empresa
                    var dadosJson = {
                        "Id": $('#txtIdEmpresaModal').val(),
                        "Nome": $('#txtNomeEmpresaModal').val(),
                        "CNPJ": $('#txtCnpjEmpresaModal').inputmask('unmaskedvalue'),
                        "IdsAssociadosAdicionar": IdsAssociadosAdicionar,
                        "IdsAssociadosRemover": IdsAssociadosRemover
                    };

                    $.ajax({
                        type: "PUT", 
                        url: "api/Empresa",
                        contentType: "application/json; charset=utf-8",
                        data: JSON.stringify(dadosJson),
                        dataType: "json",
                        success: function (response) {
                            alert("Dados da empresa e associados foram salvos.");
                            // Fechar o modal
                            $('#modalAdicionarEmpresa').modal('hide');
                            getEmpresas();
                        },
                        error: function (error) {
                            alert(JSON.parse(error.responseText).Message)
                        }
                    });
                }
            }
         
            $(document).ready(function () {                
                $('#txtPesquisaCNPJ').inputmask('99.999.999/9999-99', { clearMaskOnLostFocus: false });
                $('#txtCnpjEmpresaModal').inputmask('99.999.999/9999-99', { clearMaskOnLostFocus: false });
                $('#txtPesquisaCpf').inputmask('999.999.999-99', { clearMaskOnLostFocus: false });
                $('#txtPesquisaDataNascimento').inputmask('99/99/9999');
                
                
                
                getEmpresas();
            });

            function adicionarEmpresa(id, nome, cnpj, associados) {
                var empresasTableBody = document.getElementById("empresasTableBody");

                var novaLinha = empresasTableBody.insertRow();
                var colunaId = novaLinha.insertCell(0);
                var colunaNome = novaLinha.insertCell(1);
                var colunaCnpj = novaLinha.insertCell(2);
                var colunaAcao = novaLinha.insertCell(3);

                colunaId.innerHTML = id;
                colunaNome.innerHTML = nome;
                colunaCnpj.innerHTML = adicionarMascaraCNPJ(cnpj);
                colunaAcao.innerHTML = '<button type="button" class="btn btn-danger" onclick="excluirEmpresa(this)">Excluir</button>' +
                    '<button type="button" class="btn btn-warning ml-2" onclick="editarEmpresa(this)">Editar</button>';
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

            function excluirEmpresa(botaoExcluir) {

                var linha = botaoExcluir.parentNode.parentNode;
                var idEmpresa = linha.cells[0].innerText;

                $.ajax({
                    type: "DELETE",
                    url: "api/Empresa/" + idEmpresa,
                    contentType: "application/json; charset=utf-8",
                    success: function (response) {
                        alert("Empresa Excluída");
                        linha.parentNode.removeChild(linha);
                    },
                    error: function (error) {
                        alert(JSON.parse(error.responseText).Message)
                    }
                });
            }

            let IdsAssociadosRemover = new Array();
            let IdsAssociadosAdicionar = new Array();
            var associados = "";
            function editarEmpresa(botaoEditar) {
                associados = "";
                IdsAssociadosRemover = new Array();
                IdsAssociadosAdicionar = new Array();

                // Lógica para preencher o modal de edição com os dados da empresa selecionada
                var linha = botaoEditar.parentNode.parentNode;

                var idEmpresa = linha.cells[0].innerText;
                var nomeEmpresa = linha.cells[1].innerText;
                var cnpjEmpresa = linha.cells[2].innerText;
                
                // Preencha os campos do modal de edição com os dados da empresa
                document.getElementById("txtNomeEmpresaModal").value = nomeEmpresa;
                document.getElementById("txtCnpjEmpresaModal").value = cnpjEmpresa;
                document.getElementById("txtIdEmpresaModal").value = idEmpresa;


                // Lógica para preencher a tabela de associados no modal
                $.getJSON("api/Empresa/" + idEmpresa,
                    function (data) {    
                        associados = data.Associados;                              
                        preencherTabelaAssociadosModal(associados);
                    });


                // Abre o modal de edição
                $('#modalAdicionarEmpresa').modal('show');
            }

            function adicionarNovaEmpresa(botaoAdicionar) {
                associados = "";
                IdsAssociadosRemover = new Array();
                IdsAssociadosAdicionar = new Array();

                // Preencha os campos do modal de edição com os dados da empresa
                document.getElementById("txtNomeEmpresaModal").value = "";
                document.getElementById("txtCnpjEmpresaModal").value = "";
                document.getElementById("txtIdEmpresaModal").value = "0";

                var associadosTableBody = document.getElementById("associadosEmpresaTableBody");
                associadosTableBody.innerHTML = "";

                associados = JSON.parse("[]");

                // Abre o modal de edição
                $('#modalAdicionarEmpresa').modal('show');
            }

            function preencherTabelaAssociadosModal(associados) {
                var associadosTableBody = document.getElementById("associadosEmpresaTableBody");
                associadosTableBody.innerHTML = "";

                associados.forEach(function (associado) {
                    var novaLinha = associadosTableBody.insertRow();
                    var colunaId = novaLinha.insertCell(0);
                    var colunaNome = novaLinha.insertCell(1);
                    var colunaCpf = novaLinha.insertCell(2);
                    var colunaDataNascimento = novaLinha.insertCell(3);
                    var colunaAcao = novaLinha.insertCell(4);

                    colunaId.innerHTML = associado.Id;
                    colunaNome.innerHTML = associado.Nome;
                    colunaCpf.innerHTML = adicionarMascaraCPF(associado.Cpf);
                    colunaDataNascimento.innerHTML = adicionarMascaraDataNascimento(associado.DataNascimento);
                    colunaAcao.innerHTML = '<button type="button" class="btn btn-danger" onclick="removerAssociadoModal(this)">Remover</button>';
                });
            }

            function getEmpresas() {

                let nome = $('#txtPesquisaNomeEmpresa').val();
                let cnpj = $('#txtPesquisaCNPJ').val();
                
                if (nome !== "" || cnpj !== "") {
                    getEmpresasNomeCNPJ(nome, cnpj);
                } else {
                    $.getJSON("api/Empresa",
                        function (data) {
                            var empresasTableBody = document.getElementById("empresasTableBody");
                            empresasTableBody.innerHTML = '';
                            
                            $.each(data, function (key, val) {
                                adicionarEmpresa(val.Id, val.Nome, val.CNPJ, val.Associados);
                            });
                        });
                }               
            }

            function getEmpresasNomeCNPJ(nome, cnpj) {
                const parametros = `?nome=${encodeURIComponent(nome)}&cnpj=${encodeURIComponent(cnpj)}`;
          
                const url = `api/Empresa${parametros}`;

                $.getJSON(url,
                    function (data) {
                        var empresasTableBody = document.getElementById("empresasTableBody");
                        empresasTableBody.innerHTML = '';
                        
                        $.each(data, function (key, val) {
                            adicionarEmpresa(val.Id, val.Nome, val.CNPJ, val.Associados);
                        });
                    });
            }

        </script>
    </form>
</body>
</html>
